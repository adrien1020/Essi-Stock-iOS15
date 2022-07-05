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
    
    @State var generalWidth = 300.0
    @State var generalHeigh = 300.0
    var dotColor = Color.init(white: 1).opacity(0.9)
    var surrondColor = Color.black.opacity(0.45)
    
    @State var screenHeight = 0.0
    @State var screenWidth = 0.0
    
    @State var widthLimit = 0.0
    @State var heightLimit = 0.0
    
    @State var remainingWidth = 0.0
    @State var remainingHeight = 0.0
    
    
    @State var posWidthFrame = 0.0
    @State var negWidthFrame = 0.0
    
    @State var posHeightFrame = 0.0
    @State var negHeightFrame = 0.0
    
    
    @State var dotXOffset = 0.0
    @State var dotYOffset = 0.0
    
    @State var lastDotXOffset = 0.0
    @State var lastDotYOffset = 0.0
    
    var body: some View{
        ZStack{
           
            Group{
                //Up Rectangle
                Rectangle()
                    .foregroundColor(.red.opacity(0.7))
//                    .foregroundColor(.black.opacity(0.6))
                    .frame(width: screenWidth, height: negHeightFrame)
                    .offset(y: -(generalHeigh/2)-(negHeightFrame/2)+yOffset)
                //Down Rectangle
                Rectangle()
                    .foregroundColor(.yellow.opacity(0.7))
//                    .foregroundColor(.black.opacity(0.6))
                    .frame(width: screenWidth, height: posHeightFrame)
                    .offset(y: (generalHeigh/2)+(posHeightFrame/2)+yOffset)
                
                //Right rectangle
                Rectangle()
                    .foregroundColor(.green.opacity(0.7))
//                    .foregroundColor(.black.opacity(0.6))
                    .frame(width: posWidthFrame, height: generalHeigh)
                    .offset(x: (generalWidth/2)+(posWidthFrame/2) + xOffset, y: yOffset)
                
                //Left rectangle
                Rectangle()
                    .foregroundColor(.blue.opacity(0.7))
//                    .foregroundColor(.black.opacity(0.6))
                    .frame(width: negWidthFrame, height: generalHeigh)
                    .offset(x: -(generalWidth/2) - (negWidthFrame/2) + xOffset, y: yOffset)
                
            }
            
            
            Rectangle()
                .frame(width: generalWidth, height: generalHeigh)
                .foregroundColor(.black.opacity(0.2))
                .offset(x: xOffset, y: yOffset)
                .gesture(DragGesture().onChanged { gesture in
                    
                    xOffset = gesture.translation.width + lastXOffset
                    yOffset = gesture.translation.height + lastYOffset
                    
                    posWidthFrame = (remainingWidth/2) - xOffset
                    //Limit to the right rectangle
                    if posWidthFrame <= 0{
                        posWidthFrame = 0
                    }
                    
                    if posWidthFrame >= remainingWidth{
                        posWidthFrame = remainingWidth
                    }
                    
                    negWidthFrame = (remainingWidth/2) + xOffset
                    //Limit to the left rectangle
                    if negWidthFrame <= 0{
                        negWidthFrame = 0
                    }
                    if negWidthFrame >= remainingWidth{
                        negWidthFrame = remainingWidth
                    }
                    
                    //MARK: -
                    posHeightFrame = remainingHeight/2 - yOffset
                    //Limit down rectangle
                    if posHeightFrame <= 0{
                        posHeightFrame = 0
                    }
                    if posHeightFrame >= remainingHeight{
                        posHeightFrame = remainingHeight
                    }
                    
                    negHeightFrame = remainingHeight/2 + yOffset
                    //Limit up rectangle
                    if negHeightFrame <= 0{
                        negHeightFrame = 0
                    }
                    
                    if negHeightFrame >= remainingHeight{
                        negHeightFrame = remainingHeight
                    }
                    
                    //MARK: - Direction
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
                        // Store Offset when ended drag
                        self.lastXOffset = xOffset
                        self.lastYOffset = yOffset
                    })
            
            
                .onAppear(){
                    // get screen size
                    screenHeight = UIScreen.main.bounds.height
                    screenWidth = UIScreen.main.bounds.width
                    
                    
                    //get Limit cropping in function of size of the screen
                    widthLimit = (UIScreen.main.bounds.width/2)-(generalWidth/2)
                    heightLimit = (UIScreen.main.bounds.height/2)-(generalHeigh/2)
                    
                    //calcul des marges restantes
                    remainingWidth = (screenWidth - generalWidth)
                    remainingHeight = (screenHeight - generalHeigh)
                   
                    //calcul de la taille des rectanglee horizontau
                    posWidthFrame = (screenWidth-generalWidth)/2
                    negWidthFrame = (screenWidth-generalWidth)/2
                    
                    //calcul de la taille des rectangles verticaux
                    posHeightFrame = (screenHeight-generalHeigh)/2
                    negHeightFrame = (screenHeight-generalHeigh)/2
                    
                }
            Group{
            //Create the First Rectangle
            Rectangle()
                .stroke(lineWidth: 1)
                .frame(width: generalWidth, height: generalHeigh)
                .foregroundColor(.white)
                .offset(x: xOffset, y: yOffset)
            //Create Horizontal Rectangle
            Rectangle()
                .stroke(lineWidth: 0.5)
                .frame(width: generalWidth, height: generalHeigh/3)
                .foregroundColor(.white)
                .offset(x: xOffset, y: yOffset)
            //Create Vertical Rectangle
            Rectangle()
                .stroke(lineWidth: 0.5)
                .frame(width: generalWidth/3, height: generalHeigh)
                .foregroundColor(.white)
                .offset(x: xOffset, y: yOffset)
            }
            
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .font(.system(size: 12))
                .background(Circle().frame(width: 20, height: 20).foregroundColor(dotColor))
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
                .offset(x: -(generalWidth/2)+xOffset, y: -(generalHeigh/2)+yOffset)
                .gesture(DragGesture().onChanged({ gesture in
                    
                    dotXOffset = gesture.translation.width + lastDotXOffset
                    dotYOffset = gesture.translation.height + lastDotYOffset
          
                    generalHeigh = (generalHeigh/2) - dotYOffset
                    if generalHeigh <= 120{
                        generalHeigh = 120
                    }
                    generalWidth = (generalWidth/2) - dotXOffset
                    if generalWidth <= 120{
                        generalWidth = 120
                    }
                    remainingWidth = (screenWidth - generalWidth)
                    remainingHeight = (screenHeight - generalHeigh)
                    
                    posWidthFrame = (remainingWidth/2) + generalWidth
                    negWidthFrame = (remainingWidth/2) + generalWidth
                    
                    posHeightFrame = remainingHeight/2 + generalHeigh
                    negHeightFrame = remainingHeight/2 + generalHeigh
                    
                    
                    widthLimit = (screenWidth/2)-(generalWidth/2)
                    heightLimit = (screenHeight/2)-(generalHeigh/2)
                    
                   
                }).onEnded({ _ in
                    lastDotXOffset = dotXOffset
                    lastDotYOffset = dotYOffset
                }))
                .onAppear(){
                    lastDotXOffset = -(generalWidth/2)
                    lastDotYOffset =  -(generalHeigh/2)
                }
        }
    }
}


struct CameraReaderView_Previews: PreviewProvider {
    static var previews: some View {
        CameraReaderView(showCameraReader: .constant(true))
    }
}
