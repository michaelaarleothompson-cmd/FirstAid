////
////  MedGemmaAssist.swift
////  First Aid
////
////  Created by Michaela Arleo Thompson on 5/6/26.
////
////referenced base code from Gemini
//import SwiftUI
//import MLX
//import MLXVLM
//import MLXLMCommon
//import Observation
//
//@Observable
//@MainActor
//class LocalMedGemmaViewModel {
//    var outputText = ""
//    var isProcessing = false
//    
//    // In v3.x, this is the unified thread-safe wrapper
//    private var modelContainer: ModelContainer?
//
////    func loadModel() async {
////        guard modelContainer == nil else { return }
////        do {
////            let config = ModelConfiguration(id: "google/medgemma-1.5-4b-it-mlx-q4")
////            
////            // NEW API: VLMModelFactory.shared.loadContainer is replaced by
////            // the unified loadModelContainer call
////            self.modelContainer = try await VLMModelFactory.shared.loadModelContainer(configuration: config)
////            
////            self.outputText = "MedGemma Ready"
////        } catch {
////            self.outputText = "Load Error: \(error.localizedDescription)"
////        }
////    }
//
//    func analyze(image: UIImage, question: String) async {
//        guard let container = modelContainer else { return }
//        self.isProcessing = true
//        self.outputText = ""
//        
//        guard let ciImage = CIImage(image: image) else { return }
//        
////        do {
////            // The UserInput now goes directly into the container's perform block
////            let input = UserInput(prompt: question, images: [.ciImage(ciImage)])
////            
////            // This 'perform' block is the modern thread-safe way to run inference
////            try await container.perform { context in
////                // 1. Prepare image (resizing/tokenizing)
////                let preparedInput = try await context.processor.prepare(input: input)
////                
////                // 2. Generate text
////                return try MLXLMCommon.generate(input: preparedInput, parameters: .init(), context: context) { tokens in
////                    let newText = context.tokenizer.decode(tokens: tokens)
////                    Task { @MainActor in
////                        self.outputText += newText
////                    }
////                    return .more
////                }
////            }
////        } catch {
//            self.outputText = "Inference Error: \(error.localizedDescription)"
//        }
//        self.isProcessing = false
//    }
//}
