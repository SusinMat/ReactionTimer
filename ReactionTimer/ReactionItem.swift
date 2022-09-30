//
//  ReactionItem.swift
//  ReactionTimer
//
//  Created by Matheus Martins Susin on 2022-09-30.
//

import SwiftUI

struct ReactionItem: View {
    @State var enabled: Bool
    @State var lastResponseTime: TimeInterval?
    var lastResponseTimeString: String {
        let numberString: String
        if let lastResponseTime = lastResponseTime {
            numberString = String(lastResponseTime * 1_000.0)
        } else {
            numberString = "???"
        }
        return "\(numberString) ms"
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
    }
}

struct ReactionItem_Previews: PreviewProvider {
    static var previews: some View {
        ReactionItem(enabled: true)
    }
}
