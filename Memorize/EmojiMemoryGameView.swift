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
    
    @Namespace private var dealingNamespace
    var body: some View {
        VStack {
            gameBody
            deckBody
            HStack {
                restart
                Spacer()
                shuffle
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    //@State is for temporary state that is related only to the view
    //The model isn't concerned with the dealt state of the card
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: {$0.id == card.id}) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    //Largest index is in front, so this returns a larger negative number for cards further down the deck
    private func zIndex(of card:EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: {$0.id == card.id}) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4) //.identity on a transition means no animation
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal:.opacity))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation{
                            game.choose(card)
                        }
                    }
            }
        }
        .foregroundColor(.red)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal:.identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture { //Avoids putting view on screen until after its container appears
            //"deal" cards
            withAnimation(.easeInOut(duration: 5)) {
                for card in game.cards {
                    withAnimation(dealAnimation(for: card)) {
                        deal(card)
                    }
                }
            }
        }
    }
    
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                game.shuffle()
            }
            
        }
    }
    
    var restart: some View {
        Button("Restart") {
            withAnimation {
                dealt = []
                game.restart()
            }
        }
    }
    
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
    
    
    struct CardView: View {
        let card: EmojiMemoryGame.Card
        
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    Pie(startAngle: Angle(degrees: -90), endAngle: Angle(degrees:20))
                        .padding(5)
                        .opacity(0.5)
                    Text(card.content)
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                        .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false))
                        .font(Font.system(size:DrawingConstants.fontSize))
                        .scaleEffect(scale(thatFits: geometry.size));
                }
                .cardify(isFaceUp: card.isFaceUp)
            }
        }
        
        private func scale(thatFits size: CGSize) -> CGFloat {
            min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
        }
        
        
        
        private struct DrawingConstants {
            static let fontScale: CGFloat = 0.7
            static let fontSize: CGFloat = 32
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
    }
}

