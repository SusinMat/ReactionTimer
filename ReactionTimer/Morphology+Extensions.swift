//
//  Morphology+Extensions.swift
//  ReactionTimer
//
//  Created by Matheus Martins Susin on 2022-09-30.
//

import Foundation

extension Morphology.GrammaticalNumber {
    init(count: Int) {
        switch count {
        case 1:
            self = Morphology.GrammaticalNumber.singular
        default:
            self = Morphology.GrammaticalNumber.plural
        }
    }
}

extension Morphology {
    init(number: GrammaticalNumber) {
        self.init()
        self.number = number
    }
}
