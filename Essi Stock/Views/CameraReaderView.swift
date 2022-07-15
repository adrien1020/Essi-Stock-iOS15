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
    @State private var screenSize : CGSize = CGSize(width: 0, height: 0)
    @State private var cropSize : CGSize = CGSize(width: 150, height: 150)
    
    @State private var rightWidthFrame : CGFloat = 0.0
    @State private var leftWidthFrame : CGFloat = 0.0
    @State private var upHeightFrame : CGFloat = 0.0
    @State private var downHeightFrame : CGFloat = 0.0
    
    @State private var yOffsetSize : CGFloat = 0.0
    
    @State private var xOffsetSize : CGFloat = 0.0
    
    
    @State private var xTotalOffset : CGFloat = 0.0
    @State private var yTotalOffset : CGFloat = 0.0
    
    @State private var yTopJointMagnification : CGFloat = 1.0
    @State private var yLastTopJointMagnification : CGFloat = 1.0
    
    
    
    // MARK: - Top left variable
    @State private var isLeftArrow = false
    
    @State private var xTopLeftOffset : CGFloat = 0
    @State private var yTopLeftOffset : CGFloat = 0
    
    @State private var xLastLeftOffset : CGFloat = 0.0
    @State private var yLastTopJointOffset : CGFloat = 0.0
    
    @State private var xLeftMagnification : CGFloat = 1.0
    
    @State private var xLastLeftMagnification : CGFloat = 1.0
    
    @State private var leftOffset : CGSize = CGSize(width: 0, height: 0)
    @State private var finalLeftOffset : CGSize = CGSize(width: 0, height: 0)
    
    // MARK: - Top Right variable
    @State private var xTopRightOffset : CGFloat = 0
    @State private var yTopRightOffset : CGFloat = 0
    
    @State private var xLastTopRightOffset : CGFloat = 0.0
    
    @State private var xTopRightMagnification : CGFloat = 1.0
    
    @State private var xLastTopRightMagnification : CGFloat = 1.0
    
    @State private var topRightOffset : CGSize = CGSize(width: 0, height: 0)
    @State private var finalTopRightOffset : CGSize = CGSize(width: 0, height: 0)
    
    @State private var xTotalTopRight: CGFloat = 0.0
    
    
    //MARK: - Bottom left variable
    @State private var xBottomLeftOffset : CGFloat = 0.0
    @State private var yBottomLeftOffset: CGFloat = 0.0
    
    @State private var xBottomLeftMagnification: CGFloat = 0.0
    
    @State private var xBottomRightOffset:CGFloat = 0.0
    
    var body: some View{
        ZStack{
            Rectangle()
                .foregroundColor(.red.opacity(0.7))
                .frame(width: screenSize.width, height: upHeightFrame + yTotalOffset)
                .offset(y:-(upHeightFrame+cropSize.height)/2 + leftOffset.height)
            Rectangle()
                .foregroundColor(.green.opacity(0.7))
                .frame(width: screenSize.width, height: upHeightFrame)
                .offset(y:(upHeightFrame+cropSize.height)/2)
            Rectangle()
                .foregroundColor(.gray.opacity(0.7))
                .frame(width: rightWidthFrame - xTotalTopRight, height: cropSize.height-yTotalOffset)
                .offset(x:(leftWidthFrame+cropSize.width)/2 + topRightOffset.width, y: leftOffset.height)
            Rectangle()
                .foregroundColor(.blue.opacity(0.7))
                .frame(width: leftWidthFrame+xTotalOffset, height: cropSize.height-yTotalOffset)
                .offset(x:-(leftWidthFrame+cropSize.width)/2 + leftOffset.width, y: leftOffset.height)
            
            
            //Parent rectangle
            Rectangle()
                .frame(width: isLeftArrow ? (cropSize.width)*((xLeftMagnification+xLastTopRightMagnification)-1) : (cropSize.width)*((xTopRightMagnification + xLastLeftMagnification)-1),
                       height: cropSize.height * yTopJointMagnification)
                .foregroundColor(.yellow.opacity(0.9))
                .offset(x: isLeftArrow ? leftOffset.width+finalTopRightOffset.width  : topRightOffset.width+finalLeftOffset.width ,
                        y: leftOffset.height)
            
            //Icon in the top-left corner
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .font(.system(size: 12))
                .background(Circle().frame(width: 20, height: 20).foregroundColor(.orange))
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
                .offset(x: (leftOffset.width) - (xLeftMagnification * cropSize.width)/2,
                        y: (leftOffset.height) - (yTopJointMagnification * cropSize.height)/2)
                .gesture(DragGesture().onChanged({gesture in
                    
                    isLeftArrow = true
                    
                    //Get offset gesture
                    xTopLeftOffset = gesture.translation.width + xLastLeftOffset
                    yTopLeftOffset = gesture.translation.height + yLastTopJointOffset
                    
                    //Get the ratio of crop magnification
                    xLeftMagnification = (cropSize.width-xTopLeftOffset)/cropSize.width
                    yTopJointMagnification = (cropSize.height-yTopLeftOffset)/cropSize.height
                    
                    //limit when halving cropping in x
                    if (xLeftMagnification + xLastTopRightMagnification) - 1 <= 0.5{
                        xLeftMagnification = (1 - xLastTopRightMagnification) + 0.5
                    }
                    
                    //Limit when halving cropping in y
                    if yTopJointMagnification <= 0.5{
                        yTopJointMagnification = 0.5
                    }
                    
                    //Limit on the left edges of the screen
                    if xTopLeftOffset <= -((screenSize.width-cropSize.width)/2){
                        xLeftMagnification = (leftWidthFrame/cropSize.width) + 1
                    }
                    
                    //Limit on the top edges of the screen
                    if yTopLeftOffset <= -((screenSize.height-cropSize.height)/2){
                        yTopJointMagnification = (upHeightFrame/cropSize.height) + 1
                    }
                    
                    //As you magnify, you technically need to modify offset as well, because magnification changes are not symmetric, meaning that you are modifying the magnfiication only be shifting the upper and left edges inwards, thus changing the center of the croppedingview, so the offset needs to move accordingly
                    xOffsetSize = (cropSize.width * xLastLeftMagnification)-(cropSize.width * xLeftMagnification)
                    yOffsetSize = (cropSize.height * yLastTopJointMagnification) - (cropSize.height * yTopJointMagnification)
                    
                    leftOffset.width = (finalLeftOffset.width) + (xOffsetSize)/2
                    leftOffset.height = (finalLeftOffset.height) + yOffsetSize/2
                    
                   
                     
                     /*
                     //Limit on the top edges of the screen
                     
                     if yTopLeftOffset <= -((screenSize.height-cropSize.height)/2){
                     yTopLeftOffset = -((screenSize.height-cropSize.height)/2)
                     //lastYOffset = -((screenHeight-cropHeigh)/2)
                     topLeftOffset.height = -((screenSize.height-cropSize.height)/4)
                     finalTopLeftOffset.height = topLeftOffset.height
                     let maxYMagnification = (upHeightFrame+cropSize.height)/cropSize.height
                     
                     
                     
                     
                     yTopLeftMagnification = maxYMagnification
                     yLastTopLeftMagnification = maxYMagnification
                     
                     }*/
                    xTotalOffset = leftOffset.width*2
                    yTotalOffset = leftOffset.height*2
                    
                }).onEnded({ _ in
                    
                    //Store the last gesture offset it's used for magnification calculations in x
                    if (xLeftMagnification+xLastTopRightMagnification)-1 <= 0.5{
                        //Limit when halving cropping in x
                        xLastLeftOffset = cropSize.width/2 + xLastTopRightOffset
                    } else {
                        xLastLeftOffset = xTopLeftOffset
                    }
                    
                    //Store the last gesture offset it's used for magnification calculations in y
                    if yTopJointMagnification <= 0.5{
                        yLastTopJointOffset = cropSize.height/2
                    } else {
                        yLastTopJointOffset = yTopLeftOffset
                    }
                    
                    //Store the last gesture offset when its on top limit
                    if yTopLeftOffset <= -((screenSize.height-cropSize.height)/2){
                        yLastTopJointOffset = -((screenSize.height-cropSize.height)/2)
                    }
                    
                    //Store last magnification ratio it's used for crop calculations
                    xLastLeftMagnification = xLeftMagnification
                    yLastTopJointMagnification = yTopJointMagnification
                    
                    //Store the last offset it's used for the continuation of cropping
                    finalLeftOffset = leftOffset
                }))
            
            //MARK: - Top-right gesture
            //Icon in the top-left corner
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .font(.system(size: 12))
                .background(Circle().frame(width: 20, height: 20).foregroundColor(.orange))
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
                .offset(x: (topRightOffset.width) + (xTopRightMagnification * cropSize.width)/2,
                        y: (leftOffset.height) - (yTopJointMagnification * cropSize.height)/2)
                .gesture(DragGesture().onChanged({gesture in
                    
                    isLeftArrow = false
                    
                    //Get offset gesture
                    xTopRightOffset = gesture.translation.width + xLastTopRightOffset
                    yTopRightOffset = gesture.translation.height + yLastTopJointOffset
                    
                    //Get the ratio of crop magnification
                    xTopRightMagnification = (cropSize.width+xTopRightOffset)/cropSize.width
                    yTopJointMagnification = (cropSize.height-yTopRightOffset)/cropSize.height
                    
                    //limit when halving cropping on x
                    if (xTopRightMagnification+xLastLeftMagnification)-1 <= 0.5{
                        xTopRightMagnification = (1-xLastLeftMagnification)+0.5
                    }
                    
                    //limit when halving cropping on y
                    if yTopJointMagnification <= 0.5{
                        yTopJointMagnification = 0.5
                    }
                    
                    //Limit on the right edges of the screen
                    if xTopRightOffset >= ((screenSize.width-cropSize.width)/2){
                        xTopRightMagnification = (rightWidthFrame/cropSize.width) + 1
                    }
                    
                    print(yTopRightOffset)
                    //Limit on the top edges of the screen
                    if yTopRightOffset <= -((screenSize.height-cropSize.height)/2){
                        yTopJointMagnification = (upHeightFrame/cropSize.height) + 1
                        print(yTopJointMagnification)
                    }
                    
                    
                    xOffsetSize = (cropSize.width * xLastTopRightMagnification) - (cropSize.width * xTopRightMagnification)
                    yOffsetSize = (cropSize.height * yLastTopJointMagnification) - (cropSize.height * yTopJointMagnification)
                    
                    topRightOffset.width = (finalTopRightOffset.width) - xOffsetSize/2
                    leftOffset.height = finalLeftOffset.height + yOffsetSize/2
                    
                    xTotalTopRight = topRightOffset.width*2
                    yTotalOffset = leftOffset.height*2
                    
                }).onEnded({_ in
                    
                    //Store the last gesture offset it's used for magnification calculations
                    if (xTopRightMagnification+xLastLeftMagnification)-1 <= 0.5{
                        //Limit when halving cropping
                        xLastTopRightOffset = -cropSize.width/2 + xLastLeftOffset
                    } else {
                        xLastTopRightOffset = xTopRightOffset
                    }
                    
                    //Store the last gesture offset it's used for magnification calculations in y
                    if yTopJointMagnification <= 0.5 {
                        yLastTopJointOffset = cropSize.width/2
                    } else {
                        yLastTopJointOffset = yTopRightOffset
                    }
                    
                    //Store the last gesture offset when its on top limit
                    if yTopRightOffset <= -((screenSize.height-cropSize.height)/2){
                        yLastTopJointOffset = -((screenSize.height-cropSize.height)/2)
                    }
                    
                    
                    
                    //Store last magnification ratio it's used for crop calculations
                    xLastTopRightMagnification = xTopRightMagnification
                    yLastTopJointMagnification = yTopJointMagnification
                    
                    finalLeftOffset = leftOffset
                    finalTopRightOffset = topRightOffset
                }))
            
            //MARK: - Bottom-left gesture
            //Icon in the bottom-left corner
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .font(.system(size: 12))
                .background(Circle().frame(width: 20, height: 20).foregroundColor(.orange))
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
                .offset(x: (leftOffset.width) - (xLeftMagnification * cropSize.width)/2,
                        y: (leftOffset.height) + (yTopJointMagnification * cropSize.height)/2)
                .gesture(DragGesture().onChanged({gesture in
                    
                    isLeftArrow = true
                    
                    //Get offset gesture
                    xBottomLeftOffset = gesture.translation.width + xLastLeftOffset
                    yBottomLeftOffset = gesture.translation.height + yLastTopJointOffset
                    
                    //Get the ratio of crop magnification
                    xLeftMagnification = (cropSize.width-xBottomLeftOffset)/cropSize.width
                    yTopJointMagnification = (cropSize.height-yTopLeftOffset)/cropSize.height
                    
                    //limit when halving cropping in x
                    if (xLeftMagnification + xLastTopRightMagnification) - 1 <= 0.5{
                        xLeftMagnification = (1 - xLastTopRightMagnification) + 0.5
                    }
                    
                    //Limit when halving cropping in y
                    if yTopJointMagnification <= 0.5{
                        yTopJointMagnification = 0.5
                    }
                    
                    //Limit on the left edges of the screen
                    if xBottomLeftOffset <= -((screenSize.width-cropSize.width)/2){
                        xLeftMagnification = (leftWidthFrame/cropSize.width) + 1
                    }
                    
                    //Limit on the top edges of the screen
                    if yTopLeftOffset <= -((screenSize.height-cropSize.height)/2){
                        yTopJointMagnification = (upHeightFrame/cropSize.height) + 1
                    }
                    
                    //As you magnify, you technically need to modify offset as well, because magnification changes are not symmetric, meaning that you are modifying the magnfiication only be shifting the upper and left edges inwards, thus changing the center of the croppedingview, so the offset needs to move accordingly
                    xOffsetSize = (cropSize.width * xLastLeftMagnification)-(cropSize.width * xLeftMagnification)
                    yOffsetSize = (cropSize.height * yLastTopJointMagnification) - (cropSize.height * yTopJointMagnification)
                    
                    leftOffset.width = (finalLeftOffset.width) + (xOffsetSize)/2
                    leftOffset.height = (finalLeftOffset.height) + yOffsetSize/2
                    
                   
                     
                     /*
                     //Limit on the top edges of the screen
                     
                     if yTopLeftOffset <= -((screenSize.height-cropSize.height)/2){
                     yTopLeftOffset = -((screenSize.height-cropSize.height)/2)
                     //lastYOffset = -((screenHeight-cropHeigh)/2)
                     topLeftOffset.height = -((screenSize.height-cropSize.height)/4)
                     finalTopLeftOffset.height = topLeftOffset.height
                     let maxYMagnification = (upHeightFrame+cropSize.height)/cropSize.height
                     
                     
                     
                     
                     yTopLeftMagnification = maxYMagnification
                     yLastTopLeftMagnification = maxYMagnification
                     
                     }*/
                    xTotalOffset = leftOffset.width*2
                    yTotalOffset = leftOffset.height*2
                    
                }).onEnded({ _ in
                    
                    //Store the last gesture offset it's used for magnification calculations in x
                    if (xLeftMagnification+xLastTopRightMagnification)-1 <= 0.5{
                        //Limit when halving cropping in x
                        xLastLeftOffset = cropSize.width/2 + xLastTopRightOffset
                    } else {
                        xLastLeftOffset = xBottomLeftOffset
                    }
                    
                    //Store the last gesture offset it's used for magnification calculations in y
                    if yTopJointMagnification <= 0.5{
                        yLastTopJointOffset = cropSize.height/2
                    } else {
                        yLastTopJointOffset = yTopLeftOffset
                    }
                    
                    //Store the last gesture offset when its on top limit
                    if yTopLeftOffset <= -((screenSize.height-cropSize.height)/2){
                        yLastTopJointOffset = -((screenSize.height-cropSize.height)/2)
                    }
                    
                    //Store last magnification ratio it's used for crop calculations
                    xLastLeftMagnification = xLeftMagnification
                    yLastTopJointMagnification = yTopJointMagnification
                    
                    //Store the last offset it's used for the continuation of cropping
                    finalLeftOffset = leftOffset
                }))
            
                
            
            //MARK: - Bottom-right gesture
            //Icon in the bottom-right corner
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .font(.system(size: 12))
                .background(Circle().frame(width: 20, height: 20).foregroundColor(.orange))
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
                .offset(x: (topRightOffset.width) + (xTopRightMagnification * cropSize.width)/2,
                        y: (leftOffset.height) + (yTopJointMagnification * cropSize.height)/2)
            
                
            
            
            
        }
        .onAppear(){
            //Get screen size
            screenSize.width = UIScreen.main.bounds.width
            screenSize.height = 700 //UIScreen.main.bounds.height
            
            //Get height of top and bottom rectangles according to the height of the crop and height of th screen
            upHeightFrame = (screenSize.height-cropSize.height)/2
            print(upHeightFrame)
            
            downHeightFrame = (screenSize.height-cropSize.height)/2
            print(downHeightFrame)
            
            leftWidthFrame = (screenSize.width-cropSize.width)/2
            print(leftWidthFrame)
            
            rightWidthFrame = (screenSize.width-cropSize.width)/2
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
