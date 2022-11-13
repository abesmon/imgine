//
//  Model.swift
//  imgine
//
//  Created by Алексей Лысенко on 12.11.2022.
//

import Foundation

struct Model: Identifiable {
    let name: String
    var modelFolder: URL
    
    var id: Int { modelFolder.hashValue }
}
