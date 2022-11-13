//
//  WorkingArea.swift
//  imgine
//
//  Created by Алексей Лысенко on 13.11.2022.
//

import SwiftUI

struct WorkingArea: View {
    let model: Model?
    
    var body: some View {
        if let model = model {
            ModelWorkingArea(model: model)
        } else {
            Text("Choose some model")
                .frame(width: 512, height: 512)
        }
    }
}

struct WorkingArea_Previews: PreviewProvider {
    static var previews: some View {
        WorkingArea(model: nil)
    }
}
