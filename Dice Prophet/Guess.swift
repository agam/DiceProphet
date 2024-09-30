//
//  Guess.swift
//  Dice Prophet
//
//  Created by Agam Brahma on 9/29/24.
//

import Foundation
import SwiftData

@Model
final class Guess {
    var userGuess: Int
    var actualRoll: Int
    var timestamp: Date
    
    init(userGuess: Int, actualRoll: Int, timestamp: Date) {
        self.userGuess = userGuess
        self.actualRoll = actualRoll
        self.timestamp = timestamp
    }
}
