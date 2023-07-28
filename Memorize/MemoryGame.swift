//
//  MemoryGame.swift
//  Memorize
//
//  Created by Cloudsoft on 19/03/2022.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    //Computed var so that the cards are the only source of truth
    private var indexOfTheOneAndOnlyCard: Int?{
        get { cards.indices.filter({cards[$0].isFaceUp}).oneAndOnly }
        set { cards.indices.forEach{cards[$0].isFaceUp = ($0 == newValue)}}
    }
    
    //mutating indicates that the function will alter the state
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id}),
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched
        {
            print("Card is face down and not matched")
            if let potentialMatchIndex = indexOfTheOneAndOnlyCard {
                print("potential match index is index of the one and only")
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    print("card is matched")
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyCard = chosenIndex
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        //add number of pairs of cards * 2
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        var content: CardContent
        var id: Int
    }
}

extension Array {
    var oneAndOnly: Element? {
        if (count == 1) {
            return first
        } else {
            return nil
        }
    }
}
