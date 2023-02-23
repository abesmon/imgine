//
//  ModelWorkingArea.swift
//  imgine
//
//  Created by Алексей Лысенко on 13.11.2022.
//

import SwiftUI
import MapleDiffusion

class DiffusionGenerationConfig: ObservableObject {
    @Published var prompt: String = ""
    @Published var negativePrompt: String = ""
    @Published var seed: Int?
    @Published var steps: Int = 20
    @Published var guidanceScale: Float = 7.5
}

struct ModelWorkingArea: View {
    let model: Model
    
    @StateObject private var sd = Diffusion()
    @StateObject private var config = DiffusionGenerationConfig()
    @State private var lastSeed: Int?
    @State private var image : CGImage?
    @State private var imagePublisher = Diffusion.placeholderPublisher
    @State private var progress : Double = 0
    @State private var advancedMode = false
    
    private var anyProgress : Double {
        sd.loadingProgress < 1 ? sd.loadingProgress : progress
    }
    
    var body: some View {
        VStack {
            if sd.isModelReady {
                if advancedMode {
                    AdvancedConfig(config: config)
                        .transition(.move(edge: .top))
                }
                
                HStack {
                    Button {
                        withAnimation {
                            advancedMode.toggle()
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                    
                    if image != nil {
                        Button {
                            image = nil
                        } label: {
                            Image(systemName: "trash")
                        }                        
                    }
                    
                    Spacer()
                }
                .padding()
                
                Spacer()
            }
            
            VStack {
                if config.seed == nil, let lastSeed = lastSeed {
                    Button("Last seed: \(lastSeed)") {
                        config.seed = lastSeed
                    }
                }

                ImageWithPorgressView(image: image, progress: progress)
                    .frame(minWidth: 64, maxWidth: 512, minHeight: 64, maxHeight: 512)
                    .aspectRatio(1, contentMode: .fit)
                
                Spacer()
                
                TextField("Prompt", text: $config.prompt)
                    .onSubmit {
                        let theSeed = config.seed ?? Int.random(in: 0...Int.max)
                        lastSeed = theSeed
                        self.imagePublisher = sd.generate(
                            prompt: config.prompt,
                            negativePrompt: config.negativePrompt,
                            seed: theSeed,
                            steps: config.steps,
                            guidanceScale: config.guidanceScale
                        )
                    }
                    .disabled(!sd.isModelReady || (anyProgress > 0 && anyProgress < 1))
            }
            .frame(maxWidth: 512, maxHeight: 512)
            .overlay {
                LoadingView(isLoading: !sd.isModelReady)
            }
            .cornerRadius(5)
            
            ProgressView(value: anyProgress)
                .opacity(anyProgress == 1 || anyProgress == 0 ? 0 : 1)
            
            Spacer()
        }
        .padding()
        .task {
            try! await sd.prepModels(localUrl: model.modelFolder)
        }
        // 4
        .onReceive(imagePublisher) { r in
            self.image = r.image
            self.progress = r.progress
        }
    }
}

struct ModelWorkingArea_Previews: PreviewProvider {
    static var previews: some View {
        let modelsRepo = ModelsRepository()
        ModelWorkingArea(model: modelsRepo.models.first!)
    }
}
