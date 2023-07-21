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
        AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
            if card.isMatched && !card.isFaceUp {
                Rectangle().opacity(0)
            } else {
                CardView(card)
                    .padding(4)
                    .onTapGesture {
                        game.choose(card)
                    }
            }
            
        })
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
            Pie(startAngle: Angle(degrees: -90), endAngle: Angle(degrees:20)).padding(5).opacity(0.5)
            Text(card.content).font(.largeTitle)
        }.cardify(isFaceUp: card.isFaceUp)
    }
}

private func font(in size:CGSize) -> Font {
    Font.system(size: min(size.width, size.height) + DrawingConstants.fontScale)
}

private struct DrawingConstants {
    static let fontScale: CGFloat = 0.7
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}








struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
    }
}

