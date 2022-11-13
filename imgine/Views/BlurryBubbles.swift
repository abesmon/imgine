//
//  BlurryBubbles.swift
//  imgine
//
//  Created by Алексей Лысенко on 13.11.2022.
//

import SwiftUI

struct BlurryBubbles: View {
    let text: String
    @State private var isAnimating = false
    private var offsetAnimation: Animation {
        Animation.easeInOut
            .repeatForever(autoreverses: true)
            .speed(Double.random(in: 0.2...0.4))
    }
    private var spinAnimation: Animation {
        Animation.linear
            .repeatForever(autoreverses: false)
            .speed(0.2)
    }
    
    var body: some View {
        ZStack {
            Color.clear
            
            Circle()
                .fill(Color.blue)
                .frame(width: 40, height: 40)
                .offset(x: isAnimating ? -20 : 20)
                .scaleEffect(isAnimating ? 1 : 3)
                .animation(offsetAnimation, value: isAnimating)
                .offset(y: isAnimating ? -50 : 0)
                .rotationEffect(Angle(degrees: isAnimating ? 0 : 360))
                .animation(spinAnimation, value: isAnimating)
            
            Circle()
                .fill(Color.orange)
                .frame(width: 60, height: 60)
                .offset(x: isAnimating ? -20 : 20)
                .scaleEffect(isAnimating ? 1 : 3)
                .animation(offsetAnimation, value: isAnimating)
                .offset(y: isAnimating ? -50 : 0)
                .rotationEffect(Angle(degrees: isAnimating ? -120 : 360-120))
                .animation(spinAnimation, value: isAnimating)
        }
        .blur(radius: 35)
        .background(Color.black.opacity(0.1))
        .overlay(
            Text(text)
                .font(.largeTitle)
                .foregroundColor(.black.opacity(0.5))
        )
        .onAppear {
            isAnimating = true
        }
    }
}

struct BlurryBubbles_Previews: PreviewProvider {
    static var previews: some View {
        BlurryBubbles(text: "Here goes your imagination")
            .frame(width: 512, height: 512)
    }
}
