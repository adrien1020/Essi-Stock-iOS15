//
//  CameraReaderView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 15/06/2022.
//

import SwiftUI

struct CameraReaderView: View {
    
    @Binding var showCameraReader :Bool
    
    @State var showAlert = false
    @State var takePictureIsPressed = false
    
    var body: some View {
        ZStack{
            
            CameraPreview(takePictureIsPressed: $takePictureIsPressed, showAlert: $showAlert)
            CroppingFinderView()
            VStack{
                Text("Cherchez un code à scanner ou prennez une photo pour rechercher l'article")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 50)
                    .padding(.horizontal, 20)
                Spacer()
                PhotoButtonHelper(takePictureIsPressed: $takePictureIsPressed)
            }
        }
        .alert("Your device does not support scanning a code from an item. Please use a device with a camera.", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                showCameraReader.toggle()
            }
        }
    }
}


struct CroppingFinderView: View{
    
    
   
    @State private var xOffset: CGFloat = 0.0
    @State private var yOffset: CGFloat = 0.0
    @State private var lastXOffset: CGFloat = 0.0
    @State private var lastYOffset: CGFloat = 0.0
    
    var generalWidth = (UIScreen.main.bounds.width/1)-100
    var generalHeigh = (UIScreen.main.bounds.height/2)-100
    var dotColor = Color.init(white: 1).opacity(0.9)
    var surrondColor = Color.black.opacity(0.45)
    
    @State var screenHeight = 0.0
    @State var screenWidth = 0.0
    @State var widthLimit = 0.0
    @State var heightLimit = 0.0
    
    var body: some View{
        ZStack{
            Rectangle()
                .frame(width: generalWidth, height: generalHeigh)
                .foregroundColor(.blue.opacity(0.2))
                .offset(x: xOffset, y: yOffset)
                .gesture(DragGesture().onChanged { gesture in
                    xOffset = gesture.translation.width + lastXOffset
                    yOffset = gesture.translation.height + lastYOffset
                    
                    
                    
                    if xOffset > lastXOffset{
                        print("DEBUG: Direction droit")
                        if xOffset >= widthLimit{
                            xOffset = widthLimit
                        }
                    } else {
                        print("DEBUG: Direction gauche")
                        if xOffset  <= -widthLimit{
                            xOffset = -widthLimit
                        }
                    }
                    if yOffset < lastYOffset{
                        print("DEBUG: Direction haut")
                        if yOffset <= -heightLimit{
                            yOffset = -heightLimit
                        }
                    }else {
                        print("DEBUG: Direction bas")
                        if yOffset >= heightLimit{
                            yOffset = heightLimit
                        }
                    }
                }
                    .onEnded { _ in
                        self.lastXOffset = xOffset
                        self.lastYOffset = yOffset
                        
                        
                    })
            
            
                .onAppear(){
                    screenHeight = UIScreen.main.bounds.height
                    screenWidth = UIScreen.main.bounds.width
                    
                    widthLimit = (UIScreen.main.bounds.width/2)-(generalWidth/2)
                    heightLimit = (UIScreen.main.bounds.height/2)-(generalHeigh/2)
                    
                }
            //Create the First Rectangle
            Rectangle()
                .stroke(lineWidth: 1)
                .frame(width: generalWidth, height: generalHeigh)
                .foregroundColor(.blue)
                .offset(x: xOffset, y: yOffset)
            //Create Horizontal Rectangle
            Rectangle()
                .stroke(lineWidth: 1)
                .frame(width: generalWidth, height: generalHeigh/3)
                .foregroundColor(.red)
                .offset(x: xOffset, y: yOffset)
            //Create Vertical Rectangle
            Rectangle()
                .stroke(lineWidth: 1)
                .frame(width: generalWidth/3, height: generalHeigh)
                .foregroundColor(.yellow)
                .offset(x: xOffset, y: yOffset)
        }
    }
}


struct CameraReaderView_Previews: PreviewProvider {
    static var previews: some View {
        CameraReaderView(showCameraReader: .constant(true))
    }
}

func getDimensions(width: CGFloat, heigh: CGFloat)->CGFloat{
    if heigh > width{
        return width
    }else {
        return heigh
    }
}
