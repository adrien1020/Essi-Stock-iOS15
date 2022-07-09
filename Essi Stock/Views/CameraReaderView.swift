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
    
    
    
    
    //MARK: - General size
    @State private var screenSize: CGSize = CGSize(width: 0, height: 0)
    @State private var cropSize: CGSize = CGSize(width: 150, height: 150)
    
    @State private var rightWidthFrame : CGFloat = 0.0
    @State private var leftWidthFrame : CGFloat = 0.0
    @State private var upHeightFrame : CGFloat = 0.0
    @State private var downHeightFrame : CGFloat = 0.0
    
    @State private var yOffsetSize : CGFloat = 0.0
    
    @State private var xOffsetSize : CGFloat = 0.0
    
    
    @State private var xTotalOffset = 0.0
    @State private var yTotalOffset = 0.0
    
    
    // MARK: - Top left variable
    @State private var isTopLeftArrow = false
    
    @State private var xTopLeftOffset: CGFloat = 0
    @State private var yTopLeftOffset: CGFloat = 0
    
    @State private var xLastTopLeftOffset = 0.0
    @State private var yLastTopLeftOffset = 0.0
    
    @State private var xTopLeftMagnification : CGFloat = 1.0
    @State private var yTopLeftMagnification : CGFloat = 1.0
    
    @State private var xLastTopLeftMagnification: CGFloat = 1.0
    @State private var yLastTopLeftMagnification: CGFloat = 1.0
    
    @State private var topLeftOffset : CGSize = CGSize(width: 0, height: 0)
    @State private var finalTopLeftOffset : CGSize = CGSize(width: 0, height: 0)
    
    // MARK: - Top Right variable
    @State private var xTopRightOffset: CGFloat = 0
    @State private var yTopRightOffset: CGFloat = 0
    
    
    @State private var xLastTopRightOffset = 0.0
    @State private var yLastTopRightOffset = 0.0
    
    @State private var xTopRightMagnification : CGFloat = 1.0
    
    @State private var xLastTopRightMagnification = 1.0
    
    @State private var topRightOffset : CGSize = CGSize(width: 0, height: 0)
    @State private var finalTopRightOffset : CGSize = CGSize(width: 0, height: 0)
    
    var body: some View{
        ZStack{
            Rectangle()
                .foregroundColor(.red.opacity(0.7))
                .frame(width: screenSize.width, height: upHeightFrame + yTotalOffset)
                .offset(y:-(upHeightFrame+cropSize.height)/2 + topLeftOffset.height)
            Rectangle()
                .foregroundColor(.green.opacity(0.7))
                .frame(width: screenSize.width, height: upHeightFrame)
                .offset(y:(upHeightFrame+cropSize.height)/2)
            Rectangle()
                .foregroundColor(.gray.opacity(0.7))
                .frame(width: leftWidthFrame , height: cropSize.height-yTotalOffset)
                .offset(x:(leftWidthFrame+cropSize.width)/2, y: topLeftOffset.height)
            Rectangle()
                .foregroundColor(.blue.opacity(0.7))
                .frame(width: leftWidthFrame+xTotalOffset, height: cropSize.height-yTotalOffset)
                .offset(x:-(leftWidthFrame+cropSize.width)/2 + topLeftOffset.width, y: topLeftOffset.height)
            
            
            //Parent rectangle
            Rectangle()
                .frame(width: isTopLeftArrow ? (cropSize.width)*xTopLeftMagnification : (cropSize.width)*xTopRightMagnification,
                       height: cropSize.height*yTopLeftMagnification)
                .foregroundColor(.yellow.opacity(0.9))
                .offset(x: isTopLeftArrow ? topLeftOffset.width : topRightOffset.width,
                        y: topLeftOffset.height)
            
            //Icon in the top-left corner
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .font(.system(size: 12))
                .background(Circle().frame(width: 20, height: 20).foregroundColor(.orange))
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
                .offset(x: (topLeftOffset.width) - (xTopLeftMagnification*cropSize.width)/2,
                        y: (topLeftOffset.height) - (yTopLeftMagnification*cropSize.height)/2)
                .gesture(DragGesture().onChanged({gesture in
                    
                    isTopLeftArrow = true
                    
                    //Get offset gesture
                    xTopLeftOffset = gesture.translation.width + xLastTopLeftOffset
                    yTopLeftOffset = gesture.translation.height + yLastTopLeftOffset
                    
                    //Get the ratio of crop magnification
                    xTopLeftMagnification = (cropSize.width-xTopLeftOffset)/cropSize.width
                    yTopLeftMagnification = (cropSize.height-yTopLeftOffset)/cropSize.height
                    
                    //As you magnify, you technically need to modify offset as well, because magnification changes are not symmetric, meaning that you are modifying the magnfiication only be shifting the upper and left edges inwards, thus changing the center of the croppedingview, so the offset needs to move accordingly
                    let xOffsetSize = (cropSize.width * xLastTopLeftMagnification)-(cropSize.width * xTopLeftMagnification)
                    yOffsetSize = (cropSize.height * yLastTopLeftMagnification)-(cropSize.height * yTopLeftMagnification)
                    
                    topLeftOffset.width = (finalTopLeftOffset.width) + (xOffsetSize)/2
                    topLeftOffset.height = (finalTopLeftOffset.height) + yOffsetSize/2
                    
                    //limit when halving cropping
                    if xTopLeftMagnification <= 0.5{
                        xTopLeftOffset = cropSize.width/2
                        xTopLeftMagnification = 0.5
                        xLastTopLeftMagnification = 0.5
                        topLeftOffset.width = cropSize.width/4
                        finalTopLeftOffset.width = topLeftOffset.width
                        //lastXOffset = cropWidth/2
                        
                    }
                    if yTopLeftMagnification <= 0.5{
                        yTopLeftOffset = cropSize.height/2
                        yTopLeftMagnification = 0.5
                        yLastTopLeftMagnification = 0.5
                        topLeftOffset.height = cropSize.height/4
                        finalTopLeftOffset.height = topLeftOffset.height
                        //lastYOffset = cropHeigh/2
                        
                    }
                    
                    //Limit on the left edges of the screen
                    if xTopLeftOffset <= -((screenSize.width-cropSize.width)/2){
                        xTopLeftOffset = -((screenSize.width-cropSize.width)/2)
                        //lastXOffset = -((screenWidth-cropWidth)/2)
                        topLeftOffset.width = -((screenSize.width-cropSize.width)/4)
                        finalTopLeftOffset.width = topLeftOffset.width
                        let maxXMagnification = (leftWidthFrame+cropSize.width)/cropSize.width
                        xTopLeftMagnification = maxXMagnification
                        xLastTopLeftMagnification = maxXMagnification
                        
                    }
                    
                    //Limit on the top edges of the screen
                    
                    if yTopLeftOffset <= -((screenSize.height-cropSize.height)/2){
                        yTopLeftOffset = -((screenSize.height-cropSize.height)/2)
                        //lastYOffset = -((screenHeight-cropHeigh)/2)
                        topLeftOffset.height = -((screenSize.height-cropSize.height)/4)
                        finalTopLeftOffset.height = topLeftOffset.height
                        let maxYMagnification = (upHeightFrame+cropSize.height)/cropSize.height
                        
                        
                        
                        
                        yTopLeftMagnification = maxYMagnification
                        yLastTopLeftMagnification = maxYMagnification
                    }
                    
                    /*
                     print("DEBUG x Magni: \(xMagnification)")
                     print("DEBUG y Magni: \(yTopLeftMagnification)")
                     print("DEBUG yOffsetSize \(yOffsetSize)")
                     print("DEBUG yOffsetSize \(yOffsetSize)")
                     */
                    
                    
                    yTotalOffset = topLeftOffset.height*2
                    xTotalOffset = topLeftOffset.width*2
                    
                   
                    print(topLeftOffset.width)
                }).onEnded({ _ in
                    
                    //Store last gesture offset it's used for magnification calculations
                    xLastTopLeftOffset = xTopLeftOffset
                    yLastTopLeftOffset = yTopLeftOffset
                    
                    //Store last magnification ratio it's used for crop calculations
                    xLastTopLeftMagnification = xTopLeftMagnification
                    yLastTopLeftMagnification = yTopLeftMagnification
                    
                    
                    
                    //Store the last offset it's used for the continuation of cropping
                    finalTopLeftOffset = topLeftOffset
                }))
            
            //MARK: - Top-right gesture
            //Icon in the top-left corner
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .font(.system(size: 12))
                .background(Circle().frame(width: 20, height: 20).foregroundColor(.orange))
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
                .offset(x: (topRightOffset.width) + (xTopRightMagnification*cropSize.width)/2,
                        y: (topLeftOffset.height) - (yTopLeftMagnification*cropSize.height)/2)
            
            
            
                .gesture(DragGesture().onChanged({gesture in
                    
                    isTopLeftArrow = false
                    
                    //Get offset gesture
                    xTopRightOffset = gesture.translation.width + xLastTopRightOffset
                    yTopRightOffset = gesture.translation.height + yLastTopLeftOffset
                    
                    
                    
                    //Get the ratio of crop magnification
                    xTopRightMagnification = (cropSize.width+xTopRightOffset)/cropSize.width
                    
                    yTopLeftMagnification = (cropSize.height-yTopRightOffset)/cropSize.height
                    
                    
                    xOffsetSize = (cropSize.width * xLastTopRightMagnification) - (cropSize.width*xTopRightMagnification)
                    yOffsetSize = (cropSize.height * yLastTopLeftMagnification)-(cropSize.height * yTopLeftMagnification)
                    
                    
                    topRightOffset.width = (finalTopRightOffset.width) - xOffsetSize/2
                    topLeftOffset.height = finalTopLeftOffset.height + yOffsetSize/2
                    
                    
                    
                    yTotalOffset = topLeftOffset.height*2
                    xTotalOffset = topLeftOffset.width*2
                    
                    
                    print(topRightOffset.width)
                    
                    
                    
                    
                }).onEnded({_ in
                    
                    xLastTopRightOffset = xTopRightOffset
                    yLastTopLeftOffset = yTopRightOffset
                    
                    
                    
                    //Store last magnification ratio it's used for crop calculations
                    xLastTopRightMagnification = xTopRightMagnification
                    yLastTopLeftMagnification = yTopLeftMagnification
                    
                    
                    
                    
                    
                    finalTopLeftOffset = topLeftOffset
                    finalTopRightOffset = topRightOffset
                    
                    
                    
                }))
        }
        
        .onAppear(){
            //Get screen size
            screenSize.width = UIScreen.main.bounds.width
            screenSize.height = UIScreen.main.bounds.height
            
            
            //Get height of top and bottom rectangles according to the height of the crop and height of th screen
            upHeightFrame = (screenSize.height-cropSize.height)/2
            print(upHeightFrame)
            
            downHeightFrame = (screenSize.height-cropSize.height)/2
            print(downHeightFrame)
            
            leftWidthFrame = (screenSize.width-cropSize.width)/2
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
