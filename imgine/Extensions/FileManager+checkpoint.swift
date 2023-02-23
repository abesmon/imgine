//
//  FileManager+checkpoint.swift
//  imgine
//
//  Created by Алексей Лысенко on 12.11.2022.
//

import Foundation

extension FileManager {
    func isCheckpoint(atPath path: String) -> Bool {
        return path.hasSuffix("ckpt") || path.hasPrefix("pkl")
    }
}
