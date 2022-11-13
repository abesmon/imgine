//
//  ModelCell.swift
//  imgine
//
//  Created by Алексей Лысенко on 12.11.2022.
//

import SwiftUI

struct ModelCell: View {
    let model: Model
    let isSelected: Bool
    
    var folderPressed: (() -> Void)? = nil
    var trashPressed: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            if isSelected {
                Image(systemName: "checkmark")
            } else {
                Image(systemName: "circle.fill")
            }
            
            VStack(alignment: .leading) {
                Text(model.name)
                    .font(.title)
                Text(model.modelFolder.absoluteString)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .font(.caption2)
            }
            
            Spacer()
            
            VStack {
                Button {
                    folderPressed?()
                } label: {
                    Image(systemName: "folder.fill")
                }
                
                Button {
                    trashPressed?()
                } label: {
                    Image(systemName: "trash")
                }
                
                Spacer()
            }
        }
        .padding(6)
        .background(
            ZStack {
                if isSelected {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.blue, lineWidth: 1)
                } else {
                    EmptyView()
                }
            }
        )
        .frame(height: 50)
    }
}

struct ModelCell_Previews: PreviewProvider {
    static let model = Model(name: "test",
                             modelFolder: URL(string: "file:///Users/")!)
    
    static var previews: some View {
        VStack {
            ModelCell(model: model, isSelected: true)
            
            ModelCell(model: model, isSelected: false)
        }
        .frame(width: 200)
    }
}
