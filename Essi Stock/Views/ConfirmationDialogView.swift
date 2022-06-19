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
    
    @Binding var showConfirmationDialogView : Bool
    @Binding var quantityDesired: Int
    @Binding var showCartView : Bool
    @Binding var offset: CGFloat
    
    @State var navigateToDetailsView = false
    @State var openOffset: CGFloat = 0
    
    var item: Item
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                Spacer()
                let width = geometry.size.width
                let height = geometry.size.height/2.5
                ZStack{
                    Color.white
                        .clipShape(CustomCorner(corners: [.topLeft, .topRight], radius: 30))
                        .shadow(color: Color.black, radius: 5, x: 0, y: 5)
                    VStack{
                        HStack{
                            Spacer()
                            Capsule()
                                .foregroundColor(Color.gray.opacity(0.7))
                                .frame(width: 70, height: 4, alignment: .center)
                                .padding(.top, 8)
                            Spacer()
                        }
                        HStack{
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(Color.green)
                            Text("Ajouté au panier").foregroundColor(.black)
                            Spacer()
                        }
                        .padding()
                        Spacer()
                        ItemCellHelper(navigateToDetailsView: $navigateToDetailsView, showCartView:$showCartView , item: item)
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
                        .padding(.bottom, 140)
                    }
                }
                .frame(width: width, height: height+100, alignment: .bottom)
                .offset(y: openOffset+100)
                .offset(y: offset <= -100 ? -100 : offset)
                
                .gesture(DragGesture().updating($gestureOffset, body: {value, state, transaction in
                    state = value.translation.height
                    onChange(state: state)
                }).onEnded({ _ in
                    withAnimation{
                        if offset <= -100 || offset <= 100{
                            offset = 0
                        } else {
                            offset = height+100
                            showConfirmationDialogView = false
                        }
                    }
                }))
                .onAppear{
                    openOffset = height+100
                }
                .onChange(of: showConfirmationDialogView, perform: {_ in
                    withAnimation{
                        if showConfirmationDialogView{
                            openOffset = 0
                            offset = 0
                        }else {
                            openOffset = height+100
                            offset = 0
                        }
                    }
                })
            }
            .ignoresSafeArea()
        }
    }
    func onChange(state: Double){
        DispatchQueue.main.async {
            self.offset = state
            print("DEBUG offset: \(offset)")
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


struct ConfirmationDialog_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationDialogView(showConfirmationDialogView: .constant(true), quantityDesired: .constant(2), showCartView: .constant(false), offset: .constant(0), item: Item(id: 1, marque: "Schneider", reference: "1233", image: "222", price: "1200"))
    }
}

