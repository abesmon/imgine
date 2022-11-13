//
//  CGImage+resources.swift
//  imgine
//
//  Created by Алексей Лысенко on 13.11.2022.
//

import Foundation
import AppKit

extension CGImage {
    static func fromResource(named: String) -> CGImage? {
        guard let img = NSImage(named: named) else { return nil }
        return img.cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
}
