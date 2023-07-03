//
//  ContentView.swift
//  Memorize
//
//  Created by Cloudsoft on 11/07/2021.
//

import SwiftUI
//@ObservedObject means that the view will redraw whenever the viewModel publishes a change.
struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                ForEach(game.cards) { card in
                    CardView(card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .onTapGesture {
                            game.choose(card)
                        }
                }
            }
            
        }
        .foregroundColor(.red)
        .padding(.horizontal)
    }
}


struct CardView: View {
    private let card: MemoryGame<String>.Card
    
    init(_ card: EmojiMemoryGame.Card) {
        self.card = card
    }
    var body: some View {
        ZStack{
            let shape = RoundedRectangle(cornerRadius: 20)
            if (card.isFaceUp) {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
            } else {
                shape.fill().foregroundColor(.red)
            }
            
        }
        
    }
}











struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryGameView(game: game)
        EmojiMemoryGameView(game: game)
            .preferredColorScheme(.dark)
    }
}

