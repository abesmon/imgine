//
//  AdvancedConfig.swift
//  imgine
//
//  Created by Алексей Лысенко on 13.11.2022.
//

import SwiftUI

struct AdvancedConfig: View {
    @ObservedObject var config: DiffusionGenerationConfig
    
    var body: some View {
        VStack {
            HStack {
                TextField("Negative Prompt", text: $config.negativePrompt)
                
                Spacer()
                
                Button {
                    config.negativePrompt = ""
                } label: {
                    Image(systemName: "slider.horizontal.2.gobackward")
                }
            }
            
            HStack {
                TextField("Seed", value: $config.seed, format: .number)
                    .frame(maxWidth: 100)
                
                Stepper(value: Binding<Int> {
                    config.seed ?? 0
                } set: {
                    config.seed = $0
                }, in: 0...Int.max, step: 1) {
                    EmptyView()
                }
                
                Spacer()
                
                Button {
                    config.seed = nil
                } label: {
                    Image(systemName: "slider.horizontal.2.gobackward")
                }
            }
            
            HStack {
                TextField("Steps", value: $config.steps, format: .number)
                    .frame(maxWidth: 100)

                Stepper(value: $config.steps, in: 1...Int.max, step: 1) {
                    EmptyView()
                }
                
                Spacer()
                
                Button {
                    config.steps = 20
                } label: {
                    Image(systemName: "slider.horizontal.2.gobackward")
                }
            }
            
            HStack {
                TextField("Guidance scale", value: $config.guidanceScale, format: .number)
                    .frame(maxWidth: 100)
                
                Stepper(value: $config.guidanceScale, in: 0...Float.greatestFiniteMagnitude, step: 0.1) {
                    EmptyView()
                }
                
                Spacer()
                
                Button {
                    config.guidanceScale = 7.5
                } label: {
                    Image(systemName: "slider.horizontal.2.gobackward")
                }
            }
        }
    }
}

struct AdvancedConfig_Previews: PreviewProvider {
    struct _Preview: View {
        @StateObject var config = DiffusionGenerationConfig()
        
        var body: some View {
            AdvancedConfig(config: config)
        }
    }
    static var previews: some View {
        _Preview()
    }
}
