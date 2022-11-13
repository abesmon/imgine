//
//  ModelSelector.swift
//  imgine
//
//  Created by Алексей Лысенко on 13.11.2022.
//

import SwiftUI

struct ModelSelector: View {
    @Environment(\.openURL) private var openURL
    
    @StateObject private var modelsRepo = ModelsRepository()
    @State private var isTargetedDrop = false
    
    @Binding var model: Model?
    
    var body: some View {
        ZStack {
            if isTargetedDrop {
                Image(systemName: "folder.badge.plus")
            } else {
                ScrollView {
                    VStack {
                        ForEach(modelsRepo.models) { model in
                            ModelCell(model: model,
                                      isSelected: self.model?.id == model.id) {
                                NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: model.modelFolder.path)
                            } trashPressed: {
                                modelsRepo.remove(model: model)
                            }
                            .onTapGesture {
                                self.model = model
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .frame(minWidth: 200, maxWidth: 300, maxHeight: .infinity)
        .background(Color.black.opacity(0.1))
        .onDrop(of: [.fileURL], isTargeted: $isTargetedDrop, perform: performDropActions)
    }
    
    private func performDropActions(_ providers: [NSItemProvider]) -> Bool {
        var loaded = false
        for provider in providers {
            if provider.canLoadObject(ofClass: URL.self) {
                _ = provider.loadObject(ofClass: URL.self) { url, err in
                    guard let url = url else {
                        print("shiiiet")
                        return
                    }
                    Task {
                        let name = url.deletingLastPathComponent().lastPathComponent
                        do {
                            try await modelsRepo.addModel(from: url, modelName: name)
                        } catch {
                            print(error)
                        }
                    }
                }
                loaded = loaded || true
            }
        }
        return loaded
    }
}

struct ModelSelector_Previews: PreviewProvider {
    static var previews: some View {
        ModelSelector(model: .constant(nil))
    }
}
