//
//  TextRecognition.swift
//  ScanAndRecognizeText
//
//  Created by Bruna Baudel on 21/07/23.
//

import SwiftUI
import Vision

struct TextRecognition {
    var scannedImages: [UIImage]
    @ObservedObject var recognizedContent: RecognizedContentModelView
    var didFinishRecognition: () -> Void
    
    private func getTextRecognitionRequest(with item: ScannedItem) -> VNRecognizeTextRequest {
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {return}
            
            observations.forEach { observation in
                guard let recognizedText = observation.topCandidates(1).first else { return }
                item.text += recognizedText.string
                item.text += "\n"
            }
        }
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        return request
    }
    
    func recognizeText() {
        let queue = DispatchQueue(label: "textRecognitionQueue", qos: .userInitiated)
        queue.async {
            for image in scannedImages {
                guard let cgImage = image.cgImage else {return}
                let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                
                do {
                    let item = ScannedItem()
                    item.image = image
                    try requestHandler.perform([getTextRecognitionRequest(with: item)])
                    
                    
                    DispatchQueue.main.async {
                        recognizedContent.items.append(item)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            DispatchQueue.main.async {
                didFinishRecognition()
            }
        }
    }
}
