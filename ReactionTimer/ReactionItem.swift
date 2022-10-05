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

    enum ButtonState {
        case standBy
        case ready
        case depressed
    }

    var buttonColor: Color {
        let buttonState = timerInfo.buttonState
        switch buttonState {
        case .standBy:
            return .red
        case .ready:
            return .green
        case .depressed:
            return .gray
        }
    }

    @StateObject var timerInfo: TimerInfo = TimerInfo()
    var passthroughSubject: StartStopButtonPublisher?

    init(enabled: Bool, passthroughSubject: StartStopButtonPublisher?) {
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
                Circle().foregroundColor(buttonColor)
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
        @Published var buttonState: ButtonState = .depressed

        var passthroughSubject: StartStopButtonPublisher? = nil
        var cancellables: Set<AnyCancellable> = []

        func setUpSink(passthroughSubject newPassthroughSubject: StartStopButtonPublisher?) {
            passthroughSubject = newPassthroughSubject
            if passthroughSubject != nil {
                print("Sink set up!")
            } else {
                print("Failed to set up sink.")
            }
            let typeName = type(of: self)
            passthroughSubject?.sink { [weak self] (completion) in
                switch completion {
                case .finished:
                    print("Finished!")
                case .failure(let error):
                    print("Error received via Passthrough Subject in \(typeName): \(error)")
                }
                self?.buttonState = .depressed
            } receiveValue: { [weak self] (value) in
                switch value {
                case .start:
                    print("Timer started.")
                    self?.timerEndTime = nil
                    self?.timerStartTime = Date().timeIntervalSince1970
                    self?.buttonState = .standBy
                case .stop:
                    print("Timer ended.")
                    self?.timerEndTime = Date().timeIntervalSince1970
                    self?.buttonState = .depressed
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
