//
//  d.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 06/07/2022.
//

import Foundation

/*
 Group{
     /*
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
         .frame(width: (generalWidth)/3, height: generalHeigh)
         .foregroundColor(.white)
         .offset(x: xOffset, y: yOffset)*/
 }
 */




/*
 .onAppear(){
     //Calcul la hauteur et la largeur de l'écran
     screenHeight = UIScreen.main.bounds.height
     screenWidth = UIScreen.main.bounds.width
     
     //Calcul de la marges totales restantes en horizontal et vertical
     remainingWidth = screenWidth - generalWidth
     remainingHeight = screenHeight - generalHeigh
     
     //Calcul des marges de chaque coté à l'horizontal et a la vertical
     widthLimit = remainingWidth/2
     heightLimit = remainingHeight/2
     
     //Calcul de la taille des rectangles horizontaux
     rightWidthFrame = (screenWidth-generalWidth)/2
     leftWidthFrame = (screenWidth-generalWidth)/2
     
     //Calcul de la taille des rectangles verticaux
     downHeightFrame = (screenHeight-generalHeigh)/2
     upHeightFrame = (screenHeight-generalHeigh)/2
     
     depart = generalWidth
     
 }
 
 
 */






/*
Group{
    //Up Rectangle
    Rectangle()
        .foregroundColor(.red.opacity(0.7))
    //                    .foregroundColor(.black.opacity(0.6))
        .frame(width: screenWidth, height: upHeightFrame)
        .offset(y: -(generalHeigh/2)-(upHeightFrame/2)+yOffset)
    //Down Rectangle
    Rectangle()
        .foregroundColor(.yellow.opacity(0.7))
    //                    .foregroundColor(.black.opacity(0.6))
        .frame(width: screenWidth, height: downHeightFrame)
        .offset(y: (generalHeigh/2)+(downHeightFrame/2)+yOffset)
    
    //Right rectangle
    Rectangle()
        .foregroundColor(.green.opacity(0.7))
    //                    .foregroundColor(.black.opacity(0.6))
        .frame(width: rightWidthFrame, height: generalHeigh)
        .offset(x: (generalWidth/2)+(rightWidthFrame/2)+xOffset, y: yOffset)
    
    //Left rectangle
    Rectangle()
        .foregroundColor(.blue.opacity(0.7))
    //                    .foregroundColor(.black.opacity(0.6))
        .frame(width: leftWidthFrame,  height: generalHeigh)
        .offset(x: (-(generalWidth/2)-(leftWidthFrame/2)+xOffset), y: yOffset)
    
}
*/





/*
 

 
 
 
Rectangle()
    .frame(width: generalWidth*activeMagnification, height: generalHeigh*heightMagnification)
    .foregroundColor(.red.opacity(0.2))
    .offset(x: xOffset, y: yOffset)

    .gesture(DragGesture().onChanged { gesture in
        
        xOffset = gesture.translation.width + lastXOffset
        yOffset = gesture.translation.height + lastYOffset
        
        //MARK: - pour eviter que la frame des rectangles horizontaux prennent des valeurs negatives
        rightWidthFrame = (widthLimit) - xOffset
        if rightWidthFrame <= 0{
            rightWidthFrame = 0
        }
        
        if rightWidthFrame >= remainingWidth{
            rightWidthFrame = remainingWidth
        }
        
        leftWidthFrame = widthLimit + xOffset
        if leftWidthFrame <= 0{
            leftWidthFrame = 0
        }
        if leftWidthFrame >= remainingWidth{
            leftWidthFrame = remainingWidth
        }
        
        //MARK: - pour eviter ques les rectangles verticaux prennent des valeurs negatives
        downHeightFrame = heightLimit - yOffset
        //Limit down rectangle
        if downHeightFrame <= 0{
            downHeightFrame = 0
        }
        if downHeightFrame >= remainingHeight{
            downHeightFrame = remainingHeight
        }
        
        upHeightFrame = heightLimit + yOffset
        if upHeightFrame <= 0{
            upHeightFrame = 0
        }
        
        if upHeightFrame >= remainingHeight{
            upHeightFrame = remainingHeight
        }
        
        //MARK: - Direction et set la valeur de l'offset quand celui ci arrive en limite
        if xOffset > lastXOffset{
            //print("DEBUG: Direction droit")
            if xOffset >= widthLimit{
                xOffset = widthLimit
            }
        } else {
            //print("DEBUG: Direction gauche")
            if xOffset  <= -widthLimit{
                xOffset = -widthLimit
            }
        }
        if yOffset < lastYOffset{
            //print("DEBUG: Direction haut")
            if yOffset <= -heightLimit{
                yOffset = -heightLimit
            }
        }else {
            //print("DEBUG: Direction bas")
            if yOffset >= heightLimit{
                print(heightLimit)
                yOffset = heightLimit
            }
        }
        //MARK: - DEBUG la taille des rectangles quand on déplace le scropping
        /*
        print("DEBUG: Rectangle droit largeur \(rightWidthFrame)")
        print("DEBUG: Rectangle gauche largeur \(leftWidthFrame)")
        print("DEBUG: Rectangle haut hauteur \(upHeightFrame)")
        print("DEBUG: Rectangle bas hauteur \(downHeightFrame)")
         */
    }
             
             
             
        .onEnded { _ in
            
            //Store les dermiers offsets en X et Y
            self.lastXOffset = xOffset
            self.lastYOffset = yOffset
        })
*/
