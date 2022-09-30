//
//  ContentView.swift
//  ReactionTimer
//
//  Created by Matheus Martins Susin on 2022-09-22.
//

import SwiftUI

struct ContentView: View {
    @State var testIsOngoing: Bool = false
    @State var numberOfButtons: Int = 1

    let topStackHeight = 60.0

    var body: some View {
        VStack {
            Spacer().frame(height: 16.0)
            HStack {
                minusButton
                startButton
                plusButton
            }
            .padding(.horizontal, 4.0)
            Spacer().frame(minWidth: .zero)
        }
    }
}

// MARK: - Start/Stop Button
extension ContentView {
    var buttonText: AttributedString {
        if testIsOngoing {
            return "Stop"
        } else {
            var morphology = Morphology()
            morphology.number = numberOfButtons == 1 ? .singular : .plural
            var string = AttributedString("Start (\(numberOfButtons) button)")
            string.inflect = .explicit(morphology)
            return string.inflected()
        }
    }

    var startButton: some View {
        Button {
            if testIsOngoing {
                testIsOngoing = false
            } else {
                testIsOngoing = true
            }
        } label: {
            Text(buttonText)
                .font(.system(size: 24.0))
                .foregroundColor(Color(uiColor: .systemBackground))
                .frame(maxWidth: .infinity, minHeight: topStackHeight)
        }
        .background(Color.accentColor)
        .cornerRadius(10.0)
    }
}

// MARK: - Minus and Plus Buttons
extension ContentView {
    private struct IncrementButton: View {
        let textString: String
        let action: () -> Void

        init(_ textString: String, _ action: @escaping () -> Void) {
            self.textString = textString
            self.action = action
        }

        var body: some View {
            Button {
                action()
            } label: {
                Text(textString)
                    .font(.system(size: 28.0))
                    .padding(.horizontal, 4.0)
            }
        }
    }

    var minusButton: some View {
        IncrementButton("-") {
            if numberOfButtons > 1 {
                numberOfButtons -= 1
            }
        }
    }

    var plusButton: some View {
        IncrementButton("+") {
            if numberOfButtons < 8 {
                numberOfButtons += 1
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
