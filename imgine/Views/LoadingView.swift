//
//  LoadingView.swift
//  imgine
//
//  Created by Алексей Лысенко on 12.11.2022.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    let isLoading: Bool
    
    private var animation: Animation {
        Animation.linear
            .repeatForever(autoreverses: false)
            .speed(0.1)
    }
    
    private var heartAnim: Animation {
        Animation.easeInOut
            .repeatForever(autoreverses: true)
    }
    
    var body: some View {
        if isLoading {
            Image(systemName: "seal")
                .font(.system(size: 60))
                .rotationEffect(Angle(degrees: isAnimating ? 0 : 360))
                .animation(animation, value: isAnimating)
                .scaleEffect(isAnimating ? 1 : 1.2)
                .animation(heartAnim, value: isAnimating)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.regularMaterial)
                .onAppear {
                    isAnimating = true
                }
        } else {
            EmptyView()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(isLoading: true)
    }
}
