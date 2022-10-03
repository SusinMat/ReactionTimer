//
//  ContentView.swift
//  ReactionTimer
//
//  Created by Matheus Martins Susin on 2022-09-22.
//

import SwiftUI

struct ContentView: View {
    @State var testIsOngoing: Bool = false
    @State var numberOfButtons: Int = 4

    let maxItemsPerRow = 2
    let maxRows = 4
    var buttonRange: ClosedRange<Int> { 1...(maxItemsPerRow * maxRows) }
    let topStackHeight = 60.0

    var body: some View {
        VStack {
            Spacer().frame(height: 4.0)
            HStack {
                minusButton
                    .disabled(testIsOngoing || numberOfButtons <= buttonRange.lowerBound)
                startButton
                plusButton
                    .disabled(testIsOngoing || numberOfButtons >= buttonRange.upperBound)
            }
            .padding(.horizontal, 6.0)
            grid
                .frame(minHeight: 0, maxHeight: .infinity)
                .padding(.horizontal, 6.0)
                .padding(.vertical, 4.0)
        }
    }
}

// MARK: - Grid
extension ContentView {
    struct ReactionItemModel: Hashable {
        let index: Int
        let enabled: Bool
    }

    var reactionItemModels: [[ReactionItemModel]] {
        return (0..<maxRows).map { rowNumber -> [ReactionItemModel] in
            return (0..<maxItemsPerRow).map { itemInRow -> ReactionItemModel in
                let itemID = rowNumber * maxItemsPerRow + itemInRow
                return ReactionItemModel(index: itemID, enabled: itemID < numberOfButtons)
            }
        }
    }

    var grid: some View {
        VStack {
            ForEach(reactionItemModels, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { itemInRow in
                        ReactionItem(enabled: itemInRow.enabled)
                            .frame(minWidth: 0,
                                   maxWidth: .infinity)
                    }
                }
            }
            .padding(.vertical, 0.5)
        }
    }
}

// MARK: - Start/Stop Button
extension ContentView {
    var buttonText: AttributedString {
        if testIsOngoing {
            return "Stop"
        } else {
            let morphology = Morphology(number: .init(count: numberOfButtons))
            var string = AttributedString("(\(numberOfButtons) button)")
            string.inflect = .explicit(morphology)
            return "Start " + string.inflected()
        }
    }

    var startButton: some View {
        Button {
            testIsOngoing.toggle()
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
                    .font(.system(size: 32.0))
                    .padding(.horizontal, 6.0)
                    .frame(alignment: .center)
                    .padding(.bottom, 4.0)
            }
            .overlay(
                Circle()
                    .stroke(Color.accentColor, lineWidth: 2.0)
            )
        }
    }

    var minusButton: some View {
        IncrementButton("-") {
            if numberOfButtons > buttonRange.lowerBound {
                numberOfButtons -= 1
            }
        }
    }

    var plusButton: some View {
        IncrementButton("+") {
            if numberOfButtons < buttonRange.upperBound {
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
