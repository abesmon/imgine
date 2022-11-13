//
//  Blur.swift
//  imgine
//
//  Created by Алексей Лысенко on 13.11.2022.
//

import SwiftUI

//struct Blur: UIViewRepresentable {
//    var style: UIBlurEffect.Style = .systemMaterial
//    func makeUIView(context: Context) -> UIVisualEffectView {
//        return UIVisualEffectView(effect: UIBlurEffect(style: style))
//    }
//    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
//        uiView.effect = UIBlurEffect(style: style)
//    }
//}

struct Blur: NSViewRepresentable {
    let style: NSVisualEffectView.Material = .appearanceBased
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = style
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = style
    }
}

struct Blur_Previews: PreviewProvider {
    static var previews: some View {
        Blur()
    }
}
