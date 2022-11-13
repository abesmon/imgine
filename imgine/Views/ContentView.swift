//
//  ContentView.swift
//  imgine
//
//  Created by Алексей Лысенко on 12.11.2022.
//

import SwiftUI

struct ContentView: View {
    @State var model: Model?
    
    var body: some View {
        HStack {
            ModelSelector(model: $model)
            WorkingArea(model: model)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
