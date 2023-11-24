//
//  Model.swift
//  ScanAndRecognizeText
//
//  Created by Bruna Baudel on 21/07/23.
//

import SwiftUI

class RecognizedContentModelView: ObservableObject {
    @Published var items = [ScannedItem]()
}

class ScannedItem: Identifiable {
    var id: String = UUID().uuidString
    var text: String = ""
    var image: UIImage = UIImage()
    
    init() {
    }
    
    init(text: String, image: UIImage) {
        self.text = text
        self.image = image
    }
}
