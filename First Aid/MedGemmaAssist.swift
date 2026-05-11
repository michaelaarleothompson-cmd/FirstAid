//
//  MedGemmaAssist.swift
//  First Aid
//
//  Created by Michaela Arleo Thompson on 5/6/26.
//
//referenced base code from Gemini


import CoreImage
import Foundation
import HuggingFace
import MLX
import MLXHuggingFace
import MLXLMCommon
import MLXVLM
import Observation
import Tokenizers
import UIKit

@Observable
@MainActor
final class LocalMedGemmaViewModel {
    var outputText = ""
    var statusText = "MedGemma has not loaded yet."
    var isLoading = false
    var isProcessing = false

    private let modelID = "google/medgemma-1.5-4b-it-mlx-q4"
    private var modelContainer: ModelContainer?

    var canAnalyze: Bool {
        !isLoading && !isProcessing
    }

    func resetOutput() {
        outputText = ""
    }

    func loadModelIfNeeded() async {
        guard modelContainer == nil else { return }

        isLoading = true
        statusText = "Loading MedGemma..."

        do {
            let tokenizerLoader = #huggingFaceTokenizerLoader()

            if let localDirectory = findLocalModelDirectory() {
                modelContainer = try await VLMModelFactory.shared.loadContainer(
                    from: localDirectory,
                    using: tokenizerLoader
                )
                statusText = "MedGemma ready from local model files."
            } else {
                let configuration = ModelConfiguration(id: modelID)
                modelContainer = try await VLMModelFactory.shared.loadContainer(
                    from: #hubDownloader(),
                    using: tokenizerLoader,
                    configuration: configuration
                )
                statusText = "MedGemma ready from Hugging Face cache."
            }
        } catch {
            statusText = "Could not load MedGemma: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func analyze(image: UIImage, question: String) async {
        await loadModelIfNeeded()

        guard let container = modelContainer else {
            outputText = "MedGemma is not available yet."
            return
        }

        guard let ciImage = makeCIImage(from: image) else {
            outputText = "Could not read the selected image."
            return
        }

        isProcessing = true
        outputText = ""
        statusText = "Analyzing image..."

        do {
            let prompt = """
            You are a cautious first-aid assistant. Analyze the image and answer the user's question.
            Focus on visible first-aid concerns, urgent red flags, and safe immediate steps.
            Do not provide a definitive diagnosis. Recommend emergency care for severe bleeding, trouble breathing, loss of consciousness, major burns, suspected fracture, infection signs, or uncertainty.

            User question: \(question)
            """

            let userInput = UserInput(
                prompt: prompt,
                images: [.ciImage(ciImage)]
            )
            let input = try await container.prepare(input: userInput)
            let stream = try await container.generate(
                input: input,
                parameters: GenerateParameters(maxTokens: 512, temperature: 0.2)
            )

            for await generation in stream {
                switch generation {
                case .chunk(let text):
                    outputText += text
                case .info:
                    break
                case .toolCall:
                    break
                }
            }

            if outputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                outputText = "MedGemma finished without returning text."
            }
            statusText = "Analysis complete."
        } catch {
            outputText = "Inference error: \(error.localizedDescription)"
            statusText = "Analysis failed."
        }

        isProcessing = false
    }

    private func findLocalModelDirectory() -> URL? {
        let configuredPath = UserDefaults.standard.string(forKey: "MedGemmaModelPath")
        let configuredURL = configuredPath.map { URL(fileURLWithPath: $0) }

        let fileManager = FileManager.default
        let modelFolderNames = [
            "medgemma-1.5-4b-it-mlx-q4",
            "medgemma",
            "MedGemma"
        ]

        let appDirectories = [
            Bundle.main.resourceURL,
            fileManager.urls(for: .documentDirectory, in: .userDomainMask).first,
            fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first,
            fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        ]

        let candidates = [configuredURL]
            + appDirectories.flatMap { directory in
                modelFolderNames.map { directory?.appendingPathComponent($0) }
            }

        return candidates.compactMap { $0 }.first { url in
            fileManager.fileExists(atPath: url.appendingPathComponent("config.json").path)
        }
    }

    private func makeCIImage(from image: UIImage) -> CIImage? {
        if let cgImage = image.cgImage {
            return CIImage(cgImage: cgImage)
        }

        return CIImage(image: image)
    }
}
