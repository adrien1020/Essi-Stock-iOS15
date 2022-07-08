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
            
            //CameraPreview(takePictureIsPressed: $takePictureIsPressed, showAlert: $showAlert)
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
    
    @State var cropWidth = 150.0
    @State var cropHeigh = 150.0
    var dotColor = Color.init(white: 1).opacity(0.9)
    var surrondColor = Color.black.opacity(0.45)
    
    @State var screenHeight = 0.0
    @State var screenWidth = 0.0
    
    @State var widthLimit = 0.0
    @State var heightLimit = 0.0
    
    @State var remainingWidth = 0.0
    @State var remainingHeight = 0.0
    
    
    @State var rightWidthFrame = 0.0
    @State var leftWidthFrame = 0.0
    
    @State var downHeightFrame = 0.0
    @State var upHeightFrame = 0.0
    
    
    @State var dotXOffset = 0.0
    @State var dotYOffset = 0.0
    
    @State var lastDotXOffset = 0.0
    @State var lastDotYOffset = 0.0
    
    @State var xMagnification:CGFloat = 1
    @State var yMagnification:CGFloat = 1.0
    
    @State var xLastMagnification = 1.0
    @State var yLastMagnification = 1.0
    
    @State var offset:CGSize = CGSize(width: 0, height: 0)
    @State var finalOffset:CGSize = CGSize(width: 0, height: 0)
    
    @State var xOffsetSize = 0.0
    @State var yOffsetSize = 0.0
    
    @State var totalYOffset = 0.0
    @State var totalXOffset = 0.0
    var body: some View{
        ZStack{
            Rectangle()
                .foregroundColor(.red.opacity(0.7))
                .frame(width: screenWidth, height: upHeightFrame + totalYOffset)
                .offset(y:-(upHeightFrame+cropHeigh)/2 + offset.height)
            Rectangle()
                .foregroundColor(.green.opacity(0.7))
                .frame(width: screenWidth, height: upHeightFrame)
                .offset(y:(upHeightFrame+cropHeigh)/2)
            Rectangle()
                .foregroundColor(.gray.opacity(0.7))
                .frame(width: leftWidthFrame, height: cropHeigh-totalYOffset)
                .offset(x:(leftWidthFrame+cropWidth)/2, y: offset.height)
            Rectangle()
                .foregroundColor(.blue.opacity(0.7))
                .frame(width: leftWidthFrame+totalXOffset, height: cropHeigh-totalYOffset)
                .offset(x:-(leftWidthFrame+cropWidth)/2 + offset.width, y: offset.height)
            
            
            //Parent rectangle
            Rectangle()
                .frame(width: cropWidth*xMagnification, height: cropHeigh*yMagnification)
                .foregroundColor(.yellow.opacity(0.9))
                .offset(x: offset.width, y: offset.height)
            
            //Icon in the top-left corner
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .font(.system(size: 12))
                .background(Circle().frame(width: 20, height: 20).foregroundColor(dotColor))
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
                .offset(x: (offset.width) - (xMagnification*cropWidth)/2,
                        y: (offset.height) - (yMagnification*cropHeigh)/2)
                .gesture(DragGesture().onChanged({gesture in
                    
                    //Get offset gesture
                    dotXOffset = gesture.translation.width + lastXOffset
                    dotYOffset = gesture.translation.height + lastYOffset
                    
                    //Get the ratio of crop magnification
                    xMagnification = (cropWidth-dotXOffset)/cropWidth
                    yMagnification = (cropHeigh-dotYOffset)/cropHeigh
                    
                    //As you magnify, you technically need to modify offset as well, because magnification changes are not symmetric, meaning that you are modifying the magnfiication only be shifting the upper and left edges inwards, thus changing the center of the croppedingview, so the offset needs to move accordingly
                    let xOffsetSize = (cropWidth * xLastMagnification)-(cropWidth * xMagnification)
                    let yOffsetSize = (cropHeigh * yLastMagnification)-(cropHeigh * yMagnification)
                    offset.width = finalOffset.width + xOffsetSize/2
                    offset.height = finalOffset.height + yOffsetSize/2
                    
                    //limit when halving cropping
                    if xMagnification <= 0.5{
                        dotXOffset = cropWidth/2
                        xMagnification = 0.5
                        xLastMagnification = 0.5
                        offset.width = cropWidth/4
                        finalOffset.width = offset.width
                        //lastXOffset = cropWidth/2
                        
                    }
                    if yMagnification <= 0.5{
                        dotYOffset = cropHeigh/2
                        yMagnification = 0.5
                        yLastMagnification = 0.5
                        offset.height = cropHeigh/4
                        finalOffset.height = offset.height
                        //lastYOffset = cropHeigh/2
                        
                    }
                    
                    //Limit on the left edges of the screen
                    if dotXOffset <= -((screenWidth-cropWidth)/2){
                        dotXOffset = -((screenWidth-cropWidth)/2)
                        //lastXOffset = -((screenWidth-cropWidth)/2)
                        offset.width = -((screenWidth-cropWidth)/4)
                        finalOffset.width = offset.width
                        let maxXMagnification = (leftWidthFrame+cropWidth)/cropWidth
                        xMagnification = maxXMagnification
                        xLastMagnification = maxXMagnification
                        
                    }
                    
                    //Limit on the top edges of the screen
                    
                    if dotYOffset <= -((screenHeight-cropHeigh)/2){
                        dotYOffset = -((screenHeight-cropHeigh)/2)
                        //lastYOffset = -((screenHeight-cropHeigh)/2)
                        offset.height = -((screenHeight-cropHeigh)/4)
                        finalOffset.height = offset.height
                        let maxYMagnification = (upHeightFrame+cropHeigh)/cropHeigh
                        
                        
                        
                        
                        yMagnification = maxYMagnification
                        yLastMagnification = maxYMagnification
                    }
                    
                    
                    //print("DEBUG x Magni: \(xMagnification)")
                    print("DEBUG y Magni: \(yMagnification)")
                    print("DEBUG yOffsetSize \(yOffsetSize)")
                    print("DEBUG yOffsetSize \(yOffsetSize)")
                    print(offset)
                    
                    
                    totalYOffset = offset.height*2
                    totalXOffset = offset.width*2
                }).onEnded({ _ in
                    
                    //Store last gesture offset it's used for magnification calculations
                    lastXOffset = dotXOffset
                    lastYOffset = dotYOffset
                    
                    //Store last magnification ratio it's used for crop calculations
                    xLastMagnification = xMagnification
                    yLastMagnification = yMagnification
                    
                    //Store the last offset it's used for the continuation of cropping
                    finalOffset = offset
                }))
            
            //MARK: - Top-right gesture
            //Icon in the top-left corner
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .font(.system(size: 12))
                .background(Circle().frame(width: 20, height: 20).foregroundColor(dotColor))
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
                .offset(x: (offset.width) + (xMagnification*cropWidth)/2,
                        y: (offset.height) - (yMagnification*cropHeigh)/2)
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        }
        
        .onAppear(){
            //Get screen size
            screenWidth = UIScreen.main.bounds.width
            screenHeight = UIScreen.main.bounds.height
            
            print(screenHeight)
            
            //Get height of top and bottom rectangles according to the height of the crop and height of th screen
            upHeightFrame = (screenHeight-cropHeigh)/2
            print(upHeightFrame)
            
            downHeightFrame = (screenHeight-cropHeigh)/2
            print(downHeightFrame)
            
            leftWidthFrame = (screenWidth-cropWidth)/2
            print(leftWidthFrame)
        }
        
        
    }
    
    
    
    
}


struct CroppingFinderView_Previews: PreviewProvider{
    static var previews: some View{
        
        CroppingFinderView()
        
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
        CroppingFinderView()
        
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
    }
    
}


/*
 struct CameraReaderView_Previews: PreviewProvider {
 static var previews: some View {
 CameraReaderView(showCameraReader: .constant(true))
 }
 }
 */
