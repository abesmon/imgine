//
//  ImageWithPorgressView.swift
//  imgine
//
//  Created by Алексей Лысенко on 13.11.2022.
//

import SwiftUI
import CoreImage

struct ImageWithPorgressView: View {
    let image: CGImage?
    let progress: Double
    
    var body: some View {
        ZStack {
            if let image = image {
                Image(image, scale: 1, label: Text(""))
                    .resizable()
                    .scaledToFit()
                    .onDrag {
                        image.fileURLItemProvider() ?? image.tiffItemProvider()
                    } preview: {
                        Image(image, scale: 1, label: Text(""))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                    .transition(.opacity)
            } else {
                BlurryBubbles(text: "Here goes your imagination")
                    .transition(.opacity)
            }
        }
        .animation(.linear)
    }
}

struct ImageWithPorgressView_Previews: PreviewProvider {
    struct _Preview: View {
        @State var hasImage = true
        private let image = CGImage.fromResource(named: "ApplicationIcon")
        
        var body: some View {
            VStack {
                Text(hasImage ? "hasImage" : "none")
                ImageWithPorgressView(
                    image: hasImage ? image : nil,
                    progress: 0
                )
                .onTapGesture {
                    hasImage.toggle()
                }
            }
        }
    }
    
    static var previews: some View {
        _Preview()
            .frame(width: 512, height: 512)
    }
}
