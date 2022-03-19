//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Cloudsoft on 19/03/2022.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    static let emojis = ["✈️","🚲","🚂","🚢","🚗","🚁","🚠","🚀","🛸","🏍","🚜","🛴"]
    
    @Published private(set) var model: MemoryGame<String> =
    MemoryGame<String>(numberOfPairsOfCards: 4 ){pairIndex in emojis[pairIndex]}
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    //MARK: -Intents
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}
