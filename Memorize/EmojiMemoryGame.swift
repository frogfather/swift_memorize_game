//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Cloudsoft on 19/03/2022.
//

import SwiftUI

//ObservableObject allows the class to publish changes
class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    private static let emojis = ["✈️","🚲","🚂","🚢","🚗","🚁","🚠","🚀","🛸","🏍","🚜","🛴"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 10, createCardContent: { pairIndex in
            emojis[pairIndex]
        })
    }
    
    
    //@Published dispatches a change whenever the model changes
    @Published private(set) var model = createMemoryGame()
    
    var cards: Array<Card> {
        model.cards
    }
    
    //MARK: -Intents
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
}
