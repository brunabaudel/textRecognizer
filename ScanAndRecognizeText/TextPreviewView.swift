//
//  TextPreviewView.swift
//  ScanAndRecognizeText
//
//  Created by Gabriel Theodoropoulos.
//

import SwiftUI

struct TextPreviewView: View {
    var item: ScannedItem
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Image(uiImage: item.image)
                        .resizable()
                        .scaledToFit()
                    Text(item.text)
                        .font(.body)
                        .padding()
                }
                
            }
        }
    }
}

//struct TextPreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        TextPreviewView(text: "")
//    }
//}
