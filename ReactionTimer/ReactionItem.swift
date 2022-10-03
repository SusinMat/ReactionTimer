//
//  ReactionItem.swift
//  ReactionTimer
//
//  Created by Matheus Martins Susin on 2022-09-30.
//

import Combine
import SwiftUI

struct ReactionItem: View {
    @State var enabled: Bool
    var lastResponseTime: TimeInterval? {
        guard let startTime = timerInfo.timerStartTime,
              let endTime = timerInfo.timerEndTime else {
                  return nil
        }
        return endTime - startTime
    }

    var lastResponseTimeString: String {
        let numberString: String
        if let lastResponseTime = lastResponseTime {
            let milliseconds = (lastResponseTime * 1_000.0).rounded()
            numberString = String(Int(milliseconds))
        } else {
            numberString = "???"
        }
        return "\(numberString) ms"
    }

    @StateObject var timerInfo: TimerInfo = TimerInfo()
    var passthroughSubject: PassthroughSubject<TimerControl, Error>?

    init(enabled: Bool, passthroughSubject: PassthroughSubject<TimerControl, Error>?) {
        self.enabled = enabled
        self.passthroughSubject = passthroughSubject
    }

    func setUpTimer() {
        timerInfo.setUpSink(passthroughSubject: passthroughSubject)
    }

    var body: some View {
        VStack {
            Spacer(minLength: 4.0)
            Button {
                print("Button tapped!")
            } label : {
                Circle().foregroundColor(.red)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            Text(lastResponseTimeString)
                .font(.system(size: 24.0))
                .frame(minWidth: 0, maxWidth: .infinity)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 15.0)
                .stroke(Color.primary, lineWidth: 1.0)
        )
        .opacity(enabled ? 1.0 : 0.0)
        .onAppear {
            if enabled {
                setUpTimer()
            }
        }
    }
}

extension ReactionItem {
    class TimerInfo: ObservableObject {
        var timer: Timer? = nil
        @Published var timerStartTime: TimeInterval? = nil
        @Published var timerEndTime: TimeInterval? = nil

        var passthroughSubject: PassthroughSubject<TimerControl, Error>? = nil
        var cancellables: Set<AnyCancellable> = []

        func setUpSink(passthroughSubject newPassthroughSubject: PassthroughSubject<TimerControl, Error>?) {
            passthroughSubject = newPassthroughSubject
            if passthroughSubject != nil {
                print("Sink set up!")
            } else {
                print("Failed to set up sink.")
            }
            let typeName = type(of: self)
            passthroughSubject?.sink { (completion) in
                switch completion {
                case .finished:
                    print("Finished!")
                case .failure(let error):
                    print("Error received via Passthrough Subject in \(typeName): \(error)")
                }
            } receiveValue: { [weak self] (value) in
                switch value {
                case .start:
                    print("Timer started.")
                    self?.timerEndTime = nil
                    self?.timerStartTime = Date().timeIntervalSince1970
                case .stop:
                    print("Timer ended.")
                    self?.timerEndTime = Date().timeIntervalSince1970
                }
            }.store(in: &cancellables)
        }
    }
}

struct ReactionItem_Previews: PreviewProvider {
    static var previews: some View {
        ReactionItem(enabled: true, passthroughSubject: nil)
    }
}
