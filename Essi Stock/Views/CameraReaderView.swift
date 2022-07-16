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
            /*
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
             }*/
            
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
    
    
    //MARK: - Logic variables
    
    @State private var isTopArrow: Bool = false
    @State private var isLeftArrow: Bool = false
    
    //MARK: - Magnification variables
    
    @State private var yTopMagnification : CGFloat = 1.0
    @State private var yLastTopMagnification : CGFloat = 1.0
    
    @State private var xLeftMagnification : CGFloat = 1.0
    @State private var xLastLeftMagnification : CGFloat = 1.0
    
    @State private var xRightMagnification : CGFloat = 1.0
    @State private var xLastRightMagnification : CGFloat = 1.0
    
    @State private var yBottomMagnification: CGFloat = 1.0
    @State private var yLastBottomMagnification: CGFloat = 1.0
    
    // MARK: - Gesture offset variables
    
    @State private var xTopLeftOffset : CGFloat = 0.0
    @State private var yTopLeftOffset : CGFloat = 0.0
    
    @State private var xTopRightOffset : CGFloat = 0.0
    @State private var yTopRightOffset : CGFloat = 0.0
    
    @State private var xBottomLeftOffset : CGFloat = 0.0
    @State private var yBottomLeftOffset: CGFloat = 0.0
    
    @State private var xBottomRightOffset:CGFloat = 0.0
    @State private var yBottomRightOffset: CGFloat = 0.0
    
    
    //MARK: - Top Last offset variables
    
    @State private var xLastLeftOffset : CGFloat = 0.0
    @State private var xLastRightOffset : CGFloat = 0.0
    @State private var yLastBottomOffset: CGFloat = 0.0
    @State private var yLastTopOffset : CGFloat = 0.0
    
    // MARK: - Offset variables
    
    @State private var leftOffset : CGSize = CGSize(width: 0, height: 0)
    @State private var finalLeftOffset : CGSize = CGSize(width: 0, height: 0)
    
    @State private var rightOffset : CGSize = CGSize(width: 0, height: 0)
    @State private var finalRightOffset : CGSize = CGSize(width: 0, height: 0)
    
    @State private var bottomOffset : CGSize = CGSize(width: 0, height: 0)
    @State private var finalBottomOffset: CGSize = CGSize(width: 0, height: 0)
    
    //MARK: - Total offset variables
    @State private var xTotalRightOffset: CGFloat = 0.0
    @State private var xTotalLeftOffset : CGFloat = 0.0
    @State private var yTotalBottomOffset: CGFloat = 0.0
    @State private var yTotalTopOffset : CGFloat = 0.0
    
    
    
    var body: some View{
        ZStack{
            
            //MARK: - Mask rectangles
            
            Rectangle()
                .foregroundColor(.red.opacity(0.7))
                .frame(width: screenSize.width, height: upHeightFrame + yTotalTopOffset)
                .offset(y:-(upHeightFrame+cropSize.height)/2 + leftOffset.height)
            Rectangle()
                .foregroundColor(.green.opacity(0.7))
                .frame(width: screenSize.width, height: upHeightFrame - yTotalBottomOffset)
                .offset(y:(upHeightFrame+cropSize.height)/2 + bottomOffset.height)
            Rectangle()
                .foregroundColor(.gray.opacity(0.7))
                .frame(width: rightWidthFrame - xTotalRightOffset, height: isTopArrow ? cropSize.height - (yTotalTopOffset-yTotalBottomOffset) : cropSize.height - (yTotalTopOffset - yTotalBottomOffset))
                .offset(x:(leftWidthFrame+cropSize.width)/2 + rightOffset.width, y: isTopArrow ? leftOffset.height + finalBottomOffset.height : bottomOffset.height + finalLeftOffset.height)
            Rectangle()
                .foregroundColor(.blue.opacity(0.7))
                .frame(width: leftWidthFrame+xTotalLeftOffset, height: isTopArrow ? cropSize.height - (yTotalTopOffset-yTotalBottomOffset) : cropSize.height-(yTotalTopOffset - yTotalBottomOffset))
                .offset(x:-(leftWidthFrame+cropSize.width)/2 + leftOffset.width, y: isTopArrow ? leftOffset.height + finalBottomOffset.height : bottomOffset.height + finalLeftOffset.height)
            
            //MARK: - Parent rectangle
            
            Rectangle()
                .frame(width: isLeftArrow ? (cropSize.width)*((xLeftMagnification+xLastRightMagnification)-1) : (cropSize.width)*((xRightMagnification + xLastLeftMagnification)-1),
                       height: isTopArrow ? (cropSize.height) * ((yTopMagnification + yLastBottomMagnification)-1) : (cropSize.height) * ((yBottomMagnification + yLastTopMagnification)-1))
                .foregroundColor(.clear)
                .offset(x: isLeftArrow ? leftOffset.width+finalRightOffset.width  : rightOffset.width+finalLeftOffset.width ,
                        y: isTopArrow ? leftOffset.height+finalBottomOffset.height : bottomOffset.height + finalLeftOffset.height)
            
            //MARK: - Top-Left side
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .font(.system(size: 12))
                .background(Circle().frame(width: 20, height: 20).foregroundColor(.orange))
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
                .offset(x: (leftOffset.width) - (xLeftMagnification * cropSize.width)/2,
                        y: (leftOffset.height) - (yTopMagnification * cropSize.height)/2)
                .gesture(DragGesture().onChanged({gesture in
                    
                    isLeftArrow = true
                    isTopArrow = true
                    
                    //Get offset gesture
                    xTopLeftOffset = gesture.translation.width + xLastLeftOffset
                    yTopLeftOffset = gesture.translation.height + yLastTopOffset
                    
                    //Get the ratio of crop magnification
                    xLeftMagnification = (cropSize.width-xTopLeftOffset)/cropSize.width
                    yTopMagnification = (cropSize.height-yTopLeftOffset)/cropSize.height
                    
                    //limit when halving cropping in x
                    if (xLeftMagnification + xLastRightMagnification) - 1 <= 0.5{
                        xLeftMagnification = (1 - xLastRightMagnification) + 0.5
                    }
                    
                    //Limit when halving cropping in y
                    if (yTopMagnification + yBottomMagnification) - 1 <= 0.5{
                        yTopMagnification = (1-yLastBottomMagnification) + 0.5
                    }
                    
                    //Limit on the left edges of the screen
                    if xTopLeftOffset <= -((screenSize.width-cropSize.width)/2){
                        xLeftMagnification = (leftWidthFrame/cropSize.width) + 1
                    }
                    
                    //Limit on the top edges of the screen
                    if yTopLeftOffset <= -((screenSize.height-cropSize.height)/2){
                        yTopMagnification = (upHeightFrame/cropSize.height) + 1
                    }
                    
                    //As you magnify, you technically need to modify offset as well, because magnification changes are not symmetric, meaning that you are modifying the magnfiication only be shifting the upper and left edges inwards, thus changing the center of the croppedingview, so the offset needs to move accordingly
                    let xOffsetSize = (cropSize.width * xLastLeftMagnification)-(cropSize.width * xLeftMagnification)
                    let yOffsetSize = (cropSize.height * yLastTopMagnification) - (cropSize.height * yTopMagnification)
                    
                    leftOffset.width = (finalLeftOffset.width) + (xOffsetSize)/2
                    leftOffset.height = (finalLeftOffset.height) + yOffsetSize/2
                    
                    xTotalLeftOffset = leftOffset.width*2
                    yTotalTopOffset = leftOffset.height*2
                   
                }).onEnded({ _ in
                    
                    //Store the last gesture offset it's used for magnification calculations in x
                    if (xLeftMagnification+xLastRightMagnification)-1 <= 0.5{
                        //Set value limit when halving cropping in x
                        xLastLeftOffset = cropSize.width/2 + xLastRightOffset
                    } else {
                        xLastLeftOffset = xTopLeftOffset
                    }
                    
                    //Store the last gesture offset it's used for magnification calculations in y
                    if (yTopMagnification + yLastBottomMagnification) - 1 <= 0.5{
                        //Set value limit when halving cropping in y
                        yLastTopOffset = cropSize.height/2 + yLastBottomOffset
                    } else {
                        yLastTopOffset = yTopLeftOffset
                    }
                    //Store the last gesture offset when its on left limit
                    if xTopLeftOffset <= -((screenSize.width-cropSize.width)/2){
                        xLastLeftOffset = -((screenSize.width-cropSize.width)/2)
                    }
                    
                    //Store the last gesture offset when its on top limit
                    if yTopLeftOffset <= -((screenSize.height-cropSize.height)/2){
                        yLastTopOffset = -((screenSize.height-cropSize.height)/2)
                    }
                    
                    //Store last magnification ratio it's used for crop calculations
                    xLastLeftMagnification = xLeftMagnification
                    yLastTopMagnification = yTopMagnification
                    
                    //Store the last offset it's used for the continuation of cropping
                    finalLeftOffset = leftOffset
                }))
            
            //MARK: - Top-Right side
            
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .font(.system(size: 12))
                .background(Circle().frame(width: 20, height: 20).foregroundColor(.orange))
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
                .offset(x: (rightOffset.width) + (xRightMagnification * cropSize.width)/2,
                        y: (leftOffset.height) - (yTopMagnification * cropSize.height)/2)
                .gesture(DragGesture().onChanged({gesture in
                    
                    isLeftArrow = false
                    isTopArrow = true
                    
                    //Get offset gesture
                    xTopRightOffset = gesture.translation.width + xLastRightOffset
                    yTopRightOffset = gesture.translation.height + yLastTopOffset
                    
                    //Get the ratio of crop magnification
                    xRightMagnification = (cropSize.width+xTopRightOffset)/cropSize.width
                    yTopMagnification = (cropSize.height-yTopRightOffset)/cropSize.height
                    
                    //limit when halving cropping on x
                    if (xRightMagnification+xLastLeftMagnification)-1 <= 0.5{
                        xRightMagnification = (1-xLastLeftMagnification)+0.5
                    }
                    
                    //limit when halving cropping on y
                    if (yTopMagnification + yBottomMagnification - 1) <= 0.5{
                        yTopMagnification = (1 - yLastBottomMagnification) + 0.5
                    }
                    
                    //Limit on the right edges of the screen
                    if xTopRightOffset >= ((screenSize.width-cropSize.width)/2){
                        xRightMagnification = (rightWidthFrame/cropSize.width) + 1
                    }
                    
                    //Limit on the top edges of the screen
                    if yTopRightOffset <= -((screenSize.height-cropSize.height)/2){
                        yTopMagnification = (upHeightFrame/cropSize.height) + 1
                        
                    }
                    
                    let xOffsetSize = (cropSize.width * xLastRightMagnification) - (cropSize.width * xRightMagnification)
                    let yOffsetSize = (cropSize.height * yLastTopMagnification) - (cropSize.height * yTopMagnification)
                    
                    rightOffset.width = (finalRightOffset.width) - xOffsetSize/2
                    leftOffset.height = finalLeftOffset.height + yOffsetSize/2
                    
                    xTotalRightOffset = rightOffset.width*2
                    yTotalTopOffset = leftOffset.height*2
                    
                }).onEnded({_ in
                    
                    //Store the last gesture offset it's used for magnification calculations
                    if (xRightMagnification+xLastLeftMagnification)-1 <= 0.5{
                        //Set value limit when halving cropping in x
                        xLastRightOffset = -cropSize.width/2 + xLastLeftOffset
                    } else {
                        xLastRightOffset = xTopRightOffset
                    }
                    
                    //Store the last gesture offset it's used for magnification calculations in y
                    if (yTopMagnification + yLastBottomMagnification) - 1 <= 0.5 {
                        //Set value limit when halving cropping in y
                        yLastTopOffset = cropSize.width/2 + yLastBottomOffset
                    } else {
                        yLastTopOffset = yTopRightOffset
                    }
                    
                    //Store the last gesture offset when its on right limit
                    if xTopRightOffset >= ((screenSize.width-cropSize.width)/2){
                        xLastRightOffset = ((screenSize.width-cropSize.width)/2)
                    }
                    
                    //Store the last gesture offset when its on top limit
                    if yTopRightOffset <= -((screenSize.height-cropSize.height)/2){
                        yLastTopOffset = -((screenSize.height-cropSize.height)/2)
                    }
                    
                    //Store last magnification ratio it's used for crop calculations
                    xLastRightMagnification = xRightMagnification
                    yLastTopMagnification = yTopMagnification
                    
                    //Store the last offset it's used for the continuation of cropping
                    finalLeftOffset = leftOffset
                    finalRightOffset = rightOffset
                }))
            
            //MARK: - Bottom-Left side

            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .font(.system(size: 12))
                .background(Circle().frame(width: 20, height: 20).foregroundColor(.orange))
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
                .offset(x: (leftOffset.width) - (xLeftMagnification * cropSize.width)/2,
                        y: (bottomOffset.height) + (yBottomMagnification * cropSize.height)/2)
                .gesture(DragGesture().onChanged({gesture in
                    
                    isLeftArrow = true
                    isTopArrow = false
                    
                    //Get offset gesture
                    xBottomLeftOffset = gesture.translation.width + xLastLeftOffset
                    yBottomLeftOffset = gesture.translation.height + yLastBottomOffset
                    
                    //Get the ratio of crop magnification
                    xLeftMagnification = (cropSize.width-xBottomLeftOffset)/cropSize.width
                    yBottomMagnification = (cropSize.height+yBottomLeftOffset)/cropSize.height
                    
                    //limit when halving cropping in x
                    if (xLeftMagnification + xLastRightMagnification) - 1 <= 0.5{
                        xLeftMagnification = (1 - xLastRightMagnification) + 0.5
                    }
                    
                    //Limit when halving cropping in y
                    if (yBottomMagnification + yTopMagnification) - 1 <=  0.5{
                        yBottomMagnification =  (1-yLastTopMagnification) + 0.5
                    }
                    
                    //Limit on the left edges of the screen
                    if xBottomLeftOffset <= -((screenSize.width-cropSize.width)/2){
                        xLeftMagnification = (leftWidthFrame/cropSize.width) + 1
                    }
                    
                    
                    //Limit on the top edges of the screen
                    if yBottomLeftOffset >= ((screenSize.height-cropSize.height)/2){
                        yBottomMagnification = (downHeightFrame/cropSize.height) + 1
                    }
                    
                    //As you magnify, you technically need to modify offset as well, because magnification changes are not symmetric, meaning that you are modifying the magnfiication only be shifting the upper and left edges inwards, thus changing the center of the croppedingview, so the offset needs to move accordingly
                    let xOffsetSize = (cropSize.width * xLastLeftMagnification)-(cropSize.width * xLeftMagnification)
                    let yOffsetSize = (cropSize.height * yLastBottomMagnification) - (cropSize.height * yBottomMagnification)
                    
                    leftOffset.width = (finalLeftOffset.width) + (xOffsetSize)/2
                    bottomOffset.height = (finalBottomOffset.height) - yOffsetSize/2
                    
                    xTotalLeftOffset = leftOffset.width*2
                    yTotalBottomOffset = bottomOffset.height*2
                    
                }).onEnded({ _ in
                    
                    //Store the last gesture offset it's used for magnification calculations in x
                    if (xLeftMagnification+xLastRightMagnification)-1 <= 0.5{
                        //Set value limit when halving cropping in x
                        xLastLeftOffset = cropSize.width/2 + xLastRightOffset
                    } else {
                        xLastLeftOffset = xBottomLeftOffset
                    }
                    
                    //Store the last gesture offset it's used for magnification calculations in y
                    if (yBottomMagnification + yLastTopMagnification)-1 <= 0.5{
                        //Set value limit when halving cropping in y
                        yLastBottomOffset = -cropSize.height/2 + yLastTopOffset
                    } else {
                        yLastBottomOffset = yBottomLeftOffset
                    }
                    
                    //Store the last gesture offset when its on left limit
                    if xBottomLeftOffset <= -((screenSize.width-cropSize.width)/2){
                        xLastLeftOffset = -((screenSize.width-cropSize.width)/2)
                    }
                    
                    //Store the last gesture offset when its on bottom limit
                    if yBottomLeftOffset >= ((screenSize.height-cropSize.height)/2){
                        yLastBottomOffset = ((screenSize.height-cropSize.height)/2)
                    }
                    
                    //Store last magnification ratio it's used for crop calculations
                    xLastLeftMagnification = xLeftMagnification
                    yLastBottomMagnification = yBottomMagnification
                    
                    //Store the last offset it's used for the continuation of cropping
                    finalLeftOffset = leftOffset
                    finalBottomOffset = bottomOffset
                }))
            
            //MARK: - Bottom-Right Side

            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .font(.system(size: 12))
                .background(Circle().frame(width: 20, height: 20).foregroundColor(.orange))
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
                .offset(x: (rightOffset.width) + (xRightMagnification * cropSize.width)/2,
                        y: (bottomOffset.height) + (yBottomMagnification * cropSize.height)/2)
            
                .gesture(DragGesture().onChanged({ gesture in
                    
                    isLeftArrow = false
                    isTopArrow = false
                    
                    xBottomRightOffset = gesture.translation.width + xLastRightOffset
                    yBottomRightOffset = gesture.translation.height + yLastBottomOffset
                    
                    //Get the ratio of crop magnification
                    xRightMagnification = (cropSize.width+xBottomRightOffset)/cropSize.width
                    yBottomMagnification = (cropSize.height+yBottomRightOffset)/cropSize.height
                    
                    //limit when halving cropping on x
                    if (xRightMagnification+xLastLeftMagnification)-1 <= 0.5{
                        xRightMagnification = (1-xLastLeftMagnification)+0.5
                    }
                    
                    //Limit when halving cropping in y
                    if (yBottomMagnification + yTopMagnification) - 1 <=  0.5{
                        yBottomMagnification =  (1 - yLastTopMagnification) + 0.5
                    }
                    
                    //Limit on the left edges of the screen
                    if xBottomRightOffset >= ((screenSize.width-cropSize.width)/2){
                        xRightMagnification = (rightWidthFrame/cropSize.width) + 1
                    }
                    
                    //Limit on the bottom edges of the screen
                    if yBottomRightOffset >= ((screenSize.height-cropSize.height)/2){
                        yBottomMagnification = (downHeightFrame/cropSize.height) + 1
                    }
                    
                    //As you magnify, you technically need to modify offset as well, because magnification changes are not symmetric, meaning that you are modifying the magnfiication only be shifting the upper and left edges inwards, thus changing the center of the croppedingview, so the offset needs to move accordingly
                    let xOffsetSize = (cropSize.width * xLastRightMagnification) - (cropSize.width * xRightMagnification)
                    let yOffsetSize = (cropSize.height * yLastBottomMagnification) - (cropSize.height * yBottomMagnification)
                    
                    rightOffset.width = (finalRightOffset.width) - (xOffsetSize)/2
                    bottomOffset.height = (finalBottomOffset.height) - yOffsetSize/2
                    
                    xTotalRightOffset = rightOffset.width*2
                    yTotalBottomOffset = bottomOffset.height*2
                    
                }).onEnded({ _ in
                    //Store the last gesture offset it's used for magnification calculations
                    if (xRightMagnification+xLastLeftMagnification)-1 <= 0.5{
                        //Set value limit when halving cropping in x
                        xLastRightOffset = -cropSize.width/2 + xLastLeftOffset
                    } else {
                        xLastRightOffset = xBottomRightOffset
                    }
                    
                    //Store the last gesture offset it's used for magnification calculations in y
                    if (yBottomMagnification + yLastTopMagnification)-1 <= 0.5{
                        //Set value limit when halving cropping in y
                        yLastBottomOffset = -cropSize.height/2 + yLastTopOffset
                    } else {
                        yLastBottomOffset = yBottomRightOffset
                    }
                    
                    //Store the last gesture offset when its on right limit
                    if xBottomRightOffset >= ((screenSize.width-cropSize.width)/2){
                        xLastRightOffset = ((screenSize.width-cropSize.width)/2)
                    }
                    
                    //Store the last gesture offset when its on bottom limit
                    if yBottomRightOffset >= ((screenSize.height-cropSize.height)/2){
                        yLastBottomOffset = ((screenSize.height-cropSize.height)/2)
                    }
                    
                    //Store last magnification ratio it's used for crop calculations
                    xLastRightMagnification = xRightMagnification
                    yLastBottomMagnification = yBottomMagnification
                    
                    //Store the last offset it's used for the continuation of cropping
                    finalRightOffset = rightOffset
                    finalBottomOffset = bottomOffset
                }))
        }
        .onAppear(){
            //Get screen size
            screenSize.width = UIScreen.main.bounds.width
            screenSize.height = UIScreen.main.bounds.height
            
            //Get height of top and bottom rectangles according to the height of the crop and height of th screen
            upHeightFrame = (screenSize.height-cropSize.height)/2
            downHeightFrame = (screenSize.height-cropSize.height)/2
            leftWidthFrame = (screenSize.width-cropSize.width)/2
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

struct CameraReaderView_Previews: PreviewProvider {
    static var previews: some View {
        CameraReaderView(showCameraReader: .constant(true))
    }
}

