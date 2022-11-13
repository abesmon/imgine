//
//  CGImage+ItemProvider.swift
//  imgine
//
//  Created by Алексей Лысенко on 13.11.2022.
//

import AppKit
import UniformTypeIdentifiers

extension CGImage {
    func fileURLItemProvider() -> NSItemProvider? {
        let image = NSImage(
            cgImage: self,
            size: NSSize(width: width, height: height)
        )
        guard let data = image.tiffRepresentation else {
            return nil
        }
        
        let id = UUID()
        let url = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("\(id.uuidString).tiff")
        
        do {
            try data.write(to: url)
            
            let itemProvider = NSItemProvider(
                item: url as NSSecureCoding?,
                typeIdentifier: UTType.fileURL.identifier)
            itemProvider.suggestedName = url.lastPathComponent
            return itemProvider
        } catch {
            return nil
        }
    }
    
    func tiffItemProvider() -> NSItemProvider {
        let image = NSImage(
            cgImage: self,
            size: NSSize(width: width, height: height)
        )
        return NSItemProvider(
            item: image.tiffRepresentation as NSSecureCoding?,
            typeIdentifier: UTType.tiff.identifier
        )
    }
}
