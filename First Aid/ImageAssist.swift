////
////  ImageAssist.swift
////  First Aid
////
////  Created by Michaela Arleo Thompson on 4/13/26.
////
import SwiftUI
import MLX
import Observation
import MLXVLM       // If this still fails, see Step 3 below
import MLXLMCommon  // The unified generation API


struct ImageAssist: View {
    @State private var showCamera = false
    @State private var capturedImage: UIImage?
//    @State private var medGemma = LocalMedGemmaViewModel()
    var body: some View {
                VStack(spacing: 20) {
                        Spacer().frame(height: 20)
                        Spacer().frame(height: 20)
                        Text("*Disclaimer: This page uses AI which can hallucinate. Please check with a medical professional before using any advice. *")
                            .font(.system(size: 15)).bold().foregroundColor(.red)
                           .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
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

