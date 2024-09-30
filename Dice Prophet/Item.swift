//
//  Item.swift
//  Dice Prophet
//
//  Created by Agam Brahma on 9/29/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
