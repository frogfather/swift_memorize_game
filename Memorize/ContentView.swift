//
//  ContentView.swift
//  Memorize
//
//  Created by Cloudsoft on 11/07/2021.
//

import SwiftUI

struct ContentView: View {
    let emojis = ["✈️","🚴🏻‍♂️","🚂","🚢"]
    @State var emojiCount = 4
    var body: some View {
    
        VStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
            ForEach(emojis[0..<emojiCount], id: \.self, content: { emoji in
                CardView(content: emoji).aspectRatio(2/3, contentMode: .fit)
            })
            
        }.foregroundColor(.red)
            Spacer()
        }.padding(.horizontal)
    }
}


struct CardView: View {
    var content: String
    @State var isFaceUp: Bool = true
    var body: some View {
        ZStack{
            let shape = RoundedRectangle(cornerRadius: 20)
            if (isFaceUp) {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            } else {
                shape.fill().foregroundColor(.red)
            }
            
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}











struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView()
            .preferredColorScheme(.dark)
    }
}

