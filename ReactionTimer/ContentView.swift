//
//  ContentView.swift
//  ReactionTimer
//
//  Created by Matheus Martins Susin on 2022-09-22.
//

import SwiftUI

struct ContentView: View {
    @State var testIsOngoing: Bool = false
    @State var numberOfButtons: Double = 1.0

    var buttonText: String {
        return testIsOngoing ? "Stop" : "Start"
    }

    var button: some View {
        Button {
            buttonTapped()
        } label: {
            Text(buttonText)
                .font(.system(size: 24.0))
                .foregroundColor(Color(uiColor: .systemBackground))
                .frame(minWidth: 0.0, maxWidth: .infinity)
                .padding(.vertical, 4.0)
        }
        .background(Color.accentColor)
        .cornerRadius(10.0)
        .padding(.horizontal, 16.0)
    }

    var slider: some View {
        Slider(value: $numberOfButtons, in: 1...8)
            .padding(.horizontal, 4.0)
    }

    var body: some View {
        VStack {
            Spacer().frame(height: 16.0)
            button
            slider
            Spacer().frame(minWidth: .zero)
        }
    }

    func buttonTapped() {
        if testIsOngoing {
            testIsOngoing = false
        } else {
            testIsOngoing = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
