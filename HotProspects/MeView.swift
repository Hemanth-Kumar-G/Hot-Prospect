//
//  MeView.swift
//  HotProspects
//
//  Created by HEMANTH on 04/02/23.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct MeView: View {
    
    @State private var name = "Hemanth Kumar G"
    @State private var emailAddress = "hemanthappu006@gmail.com"
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    @State private var qrCode = UIImage()

    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title2)
                
                TextField("Email address", text: $emailAddress)
                    .textContentType(.emailAddress)
                    .font(.title2)
                
                Image(uiImage:qrCode)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 200,height: 200)
                    .contextMenu{
                        Button{
                            let imageSaver = ImageSaver()
                            imageSaver.writeToPhotoAlbum(image: qrCode)
                        } label: {
                            Label("save to phone ", systemImage: "square.and.arrow.down")
                        }
                    }
            }
            .navigationTitle("your code")
            .onAppear(perform: updateCode)
            .onChange(of: name ) { _ in updateCode() }
            .onChange(of: emailAddress) { _ in updateCode() }
        }
    }
    
    func updateCode() {
        qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
    }
    
    func generateQRCode(from string:String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent){
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
