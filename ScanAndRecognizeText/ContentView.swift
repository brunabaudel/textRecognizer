//
//  ContentView.swift
//  ScanAndRecognizeText
//
//  Created by Gabriel Theodoropoulos.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var recognizedContent = RecognizedContentModelView()
    
    @State private var showScanner = false
    @State private var isRecognizing = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                List(recognizedContent.items, id: \.id) { item in
                    NavigationLink(destination: TextPreviewView(item: item)) {
                        Text(String(item.text.prefix(30)).appending("..."))
                    }
                }
                
                if isRecognizing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(UIColor.systemIndigo)))
                        .padding(.bottom, 20)
                }
                
            }
            .navigationTitle("Text Scanner")
            .navigationBarItems(trailing: Button(action: {
                guard !isRecognizing else { return }
                showScanner = true
            }, label: {
                HStack {
                    Image(systemName: "doc.text.viewfinder")
                        .renderingMode(.template)
                        .foregroundColor(.white)
                    
                    Text("Scan")
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .frame(height: 36)
                .background(Color(UIColor.systemIndigo))
                .cornerRadius(18)
            }))
        }
        .sheet(isPresented: $showScanner, content: {
            ScannerView { result in
                switch result {
                    case .success(let scannedImages):
                        isRecognizing = true
                        TextRecognition(scannedImages: scannedImages,
                                        recognizedContent: recognizedContent) {
                            isRecognizing = false
                        }
                        .recognizeText()
                    case .failure(let error):
                    print(error.localizedDescription)
                }
                showScanner = false
            } didCancelScanning: {
                showScanner = false
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
