//
//  ImageAssist.swift
//  First Aid
//
//  Created by Michaela Arleo Thompson on 4/13/26.
//
//referenced base code from Gemini

import SwiftUI
import UIKit

struct ImageAssist: View {
    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    @State private var question = "What first-aid steps should I take for what is visible in this image?"
    @State private var medGemma = LocalMedGemmaViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("*Disclaimer: This page uses AI which can hallucinate. Please check with a medical professional before using any advice.*")
                    .font(.system(size: 15))
                    .bold()
                    .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)

                imagePreview

                HStack {
                    Button {
                        showCamera = true
                    } label: {
                        Label("Take Photo", systemImage: "camera.fill")
                            .font(.headline)
                    }
                    .buttonStyle(.borderedProminent)

                    if capturedImage != nil {
                        Button {
                            saveToGallery()
                        } label: {
                            Label("Save", systemImage: "square.and.arrow.down")
                        }
                        .buttonStyle(.bordered)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Question")
                        .font(.headline)
                    TextEditor(text: $question)
                        .frame(minHeight: 90)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.35))
                        )
                }

                Button {
                    guard let image = capturedImage else { return }
                    Task {
                        await medGemma.analyze(image: image, question: question)
                    }
                } label: {
                    if medGemma.isLoading || medGemma.isProcessing {
                        Label("Working...", systemImage: "hourglass")
                    } else {
                        Label("Analyze Photo", systemImage: "sparkles")
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(capturedImage == nil || !medGemma.canAnalyze)

                statusView
                responseView
            }
            .padding()
        }
        .navigationTitle("Image Assist")
        .sheet(isPresented: $showCamera) {
            CameraPicker(selectedImage: $capturedImage)
        }
    }

    private var imagePreview: some View {
        Group {
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.secondary.opacity(0.2))
                    .frame(height: 300)
                    .overlay(Text("No image captured").foregroundColor(.secondary))
            }
        }
    }

    private var statusView: some View {
        HStack(spacing: 10) {
            if medGemma.isLoading || medGemma.isProcessing {
                ProgressView()
            }

            Text(medGemma.statusText)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }

    @ViewBuilder
    private var responseView: some View {
        if !medGemma.outputText.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("MedGemma Response")
                    .font(.headline)
                Text(medGemma.outputText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.secondary.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    private func saveToGallery() {
        guard let image = capturedImage else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

struct ImageAssistPreview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ImageAssist()
        }
    }
}
