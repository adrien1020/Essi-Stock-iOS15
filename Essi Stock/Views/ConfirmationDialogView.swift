//
//  ConfirmationDialogView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 17/06/2022.
//

import SwiftUI

struct ConfirmationDialogView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @GestureState var gestureOffset = 0.0
    
    @Binding var offset: CGFloat
    @Binding var showConfirmationDialogView : Bool
    @Binding var quantityDesired: Int
    @Binding var showCartView : Bool
    
    @State var lastOffset : CGFloat = 0
    
    var item: Item
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                let width = geometry.size.width
                let height = (geometry.size.height/2.5)
                Spacer()
                ZStack{
                    Color.white
                        .clipShape(CustomCorner(corners: [.topLeft, .topRight], radius: 30))
                        .shadow(color: Color.black, radius: 5, x: 0, y: 5)
                    VStack{
                        Capsule()
                            .foregroundColor(Color.gray.opacity(0.7))
                            .frame(width: 70, height: 4, alignment: .center)
                            .padding(.top, 8)
                        HStack{
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(Color.green)
                            Text("Ajouté au panier").foregroundColor(.black)
                            Text("\(quantityDesired)")
                            Text(item.marque)
                            Spacer()
                        }
                        .padding()
                        Spacer()
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                                showCartView.toggle()
                            })
                        }, label: {
                            Text("Voir le panier")
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .padding()
                                .padding(.horizontal, 40)
                                .background(Color("Orange Color"))
                                .cornerRadius(15)
                            
                        })
                        .padding(.bottom, 120)
                    }
                }
                
                .frame(width: width, height: height + 100, alignment: .bottom)
                .offset(y: showConfirmationDialogView ? 0 : height)
                .offset(y: offset <= -20 ? -10 : offset + 100)
                .gesture(DragGesture().updating($gestureOffset, body: {value, state, transaction in
                    state = value.translation.height
                    print(state)
                    
                    
                    
                    
                    onChange(state: state)
                }).onEnded({ value in
                    
                    
                    
                    
                    let maxHeight = height
                    if offset<0{
                        withAnimation{
                            offset = 0
                        }
                    }
                    if offset > 50{
                        withAnimation{
                            offset = maxHeight
                        }
                    }
                    lastOffset = self.offset
                    print("DEBUG: last offset = \(lastOffset)")
                }))
            }
            .ignoresSafeArea()
            //.ignoresSafeArea(.all, edges: .bottom)
        }
    }
    func onChange(state: Double){
        DispatchQueue.main.async {
            self.offset = state + lastOffset
        }
    }
}


struct CustomCorner: Shape {
    
    var corners : UIRectCorner
    var radius : CGFloat
    
    func path(in rect: CGRect)->Path{
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

/*
 struct ConfirmationDialog_Previews: PreviewProvider {
 static var previews: some View {
 ConfirmationDialog()
 }
 }
 */
