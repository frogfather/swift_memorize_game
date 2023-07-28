//
//  Cardify.swift
//  Memorize
//
//  Created by John Campbell on 21/07/2023.
//

import SwiftUI

//AnimatableModifier hands responsibility for animation to us
//We can specify which elements we want to be animated
//The elements being animated have to conform to Animatable
struct Cardify: AnimatableModifier {
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    //This effectively tells SwiftUi what we want to be animated.
    //The other transitions such as opacity and the flip from front to back
    //are not animated.
    //The animatableData variable could be used directly but reduces readability
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    //To allow the card view to switch from back to front we need to animate rotation
    var rotation: Double //in degrees
    
    func body(content:Content) -> some View {
        ZStack{
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if (rotation < 90) {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            } else {
                shape.fill()
            }
            content
                .opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}
    extension View {
        func cardify(isFaceUp: Bool) -> some View {
            self.modifier(Cardify(isFaceUp: isFaceUp))
        }

}

