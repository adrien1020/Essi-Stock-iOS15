//
//  PhotoButtonHelper.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 15/06/2022.
//

import SwiftUI

struct PhotoButtonHelper: View {
    
    @State var scale : CGFloat = 1.0
    
    @Binding  var takePictureIsPressed: Bool
    
    var body: some View {
        
        VStack{
            Spacer()
            Button(action: {
                takePictureIsPressed.toggle()
            }, label: {
                ZStack{
                    Circle()
                        .fill(Color.white)
                        .frame(width: 65, height: 65)
                        .scaleEffect(scale)
                    Circle()
                        .stroke(Color.white,lineWidth: 4)
                        .frame(width: 75, height: 75)
                }
            })
        }
    }
}


/*
 struct PhotoButtonHelper_Previews: PreviewProvider {
 static var previews: some View {
 PhotoButtonHelper()
 }
 }
 */
