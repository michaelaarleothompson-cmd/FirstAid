////
////  ImageAssist.swift
////  First Aid
////
////  Created by Michaela Arleo Thompson on 4/13/26.
////
import SwiftUI
////import MLX
//import MLXVLM       // If this still fails, see Step 3 below
//import MLXLMCommon  // The unified generation API
//
//@MainActor
//class LocalMedGemmaViewModel: ObservableObject {
//  @Published var outputText = ""
//  @Published var isLoading = false
//
//    // Updated 2026 Type
//  private var modelContext: VLMModelContext?
//
// func loadModel() async {
//isLoading = true
//do {
//         // Updated Factory Pattern for v3.x
//          let modelID = "google/medgemma-1.5-4b-it-mlx-q4"
//
//// This now handles both the download and the logic setup
//        self.modelContext = try await VLMModelFactory.shared.load(modelID: modelID)
//
//          self.outputText = "MedGemma Ready"
//       } catch {
//            self.outputText = "Error: \(error.localizedDescription)"
//       }
//      isLoading = false
//    }
//
//    func analyze(image: UIImage, question: String) async {
//       guard let context = modelContext else { return }
//        self.outputText = ""
//
//        // Convert image
//     guard let ciImage = CIImage(image: image) else { return }
//
//        // The 2026 'generate' pattern
//        do {
//            let input = UserInput(prompt: question, images: [.ciImage(ciImage)])
//
//            // Streaming generation
//            for try await result in try await context.generate(input: input) {
//                self.outputText += result.text
//            }
//        } catch {
//            self.outputText = "Inference Error: \(error)"
//        }
//    }
//}
struct ImageAssist: View {
    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    
    var body: some View {
                VStack(spacing: 20) {
                    if let image = capturedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .cornerRadius(12)
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.secondary.opacity(0.2))
                            .frame(height: 300)
                            .overlay(Text("No image captured").foregroundColor(.secondary))
                    }
        
                    Button(action: {
                        showCamera = true
                    }) {
                        Label("Take Photo", systemImage: "camera.fill")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
        
                    if capturedImage != nil {
                        Button("Save to Library") {
                            saveToGallery()
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .sheet(isPresented: $showCamera) {
                    CameraPicker(selectedImage: $capturedImage)
                }
            }
        
        func saveToGallery() {
            guard let image = capturedImage else { return }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
    struct ImageAssistPreview: PreviewProvider {
        static var previews: some View {
            ImageAssist()
        }
    }

