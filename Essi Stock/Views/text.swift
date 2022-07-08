//
//  text.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 07/07/2022.
//

import SwiftUI

struct text: View {
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    let rect: CGFloat = 150.0
    var body: some View {
        ZStack(){
            Rectangle().ignoresSafeArea()
                .frame(width: width, height: (height-rect)/2)
                .foregroundColor(Color.green)
                .offset(y: -247)
                
            Rectangle().ignoresSafeArea()
                .frame(width: rect, height: rect)
                .foregroundColor(Color.red)
            Rectangle().ignoresSafeArea()
                .frame(width: width, height: (height-rect)/2)
                .foregroundColor(Color.yellow)
                .offset(y: 247)
                .ignoresSafeArea()
        }
        
       
    }
}

struct text_Previews: PreviewProvider {
    static var previews: some View {
        text()
    }
}

