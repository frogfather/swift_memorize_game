//
//  Cardify.swift
//  Memorize
//
//  Created by John Campbell on 21/07/2023.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool
    
    func body(content:Content) -> some View {
        ZStack{
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if (isFaceUp) {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                content
            } else {
                shape.fill()
            }
        }
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }

}

