//
//  StepperHelper.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 16/06/2022.
//

import SwiftUI

struct StepperHelper: View {
    
    @Binding var quantity : Int
    
    var body: some View {
        HStack{
            Button(action: {
                quantity -= 1
            }, label: {
                Circle()
                    .stroke(Color("Orange Color"), lineWidth: 2)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Text("-")
                            .foregroundColor(Color("Orange Color"))
                    )
            })
            .disabled(quantity <= 1)
            Text(String(quantity))
                .frame(width: 25)
            Button(action: {
                quantity += 1
            }, label: {
                Circle()
                    .stroke(Color("Orange Color"), lineWidth: 2)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Text("+")
                            .foregroundColor(Color("Orange Color"))
                    )
            })
        }
    }
}


struct StepperHelper_Previews: PreviewProvider {
    
    static var previews: some View {
        StepperHelper(quantity: .constant(2))
    }
}
