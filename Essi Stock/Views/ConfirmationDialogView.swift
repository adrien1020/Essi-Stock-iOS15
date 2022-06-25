//
//  ConfirmationDialogView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 17/06/2022.
//

import SwiftUI

struct ConfirmationDialogView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @GestureState private var gestureOffset = 0.0
    
    @Binding var showConfirmationDialogView : Bool
    @Binding var quantityDesired: Int
    @Binding var showCartView : Bool
    
    @State private var offset: CGFloat = 0.0
    @State private var openOffset: CGFloat = 0
    
    private let exceedHeight: CGFloat = 50
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
                    VStack(spacing: 10){
                        //Capsule
                        HStack{
                            Spacer()
                            Capsule()
                                .foregroundColor(Color.gray.opacity(0.7))
                                .frame(width: 70, height: 4, alignment: .center)
                                .padding(.top, 8)
                            Spacer()
                        }
                        //Checkmark icon + Text add to cart
                        HStack{
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(Color.green)
                            Text("Ajouté au panier")
                                .font(.callout.bold())
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.leading, 10)
                        .padding(.top, 10)
                        Spacer()
                        // Item cell
                        ItemConfimationDialogHelper(item: item)
                            .padding(.horizontal, 4)
                        Spacer()
                        //Button add to cart
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                                showCartView.toggle()
                            })
                        }, label: {
                            Text("Accéder le panier")
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .padding()
                                .padding(.horizontal, 40)
                                .background(Color("Orange Color"))
                                .cornerRadius(15)
                        })
                        //.padding(.bottom, exceedHeight+40)
                        .padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! + 40)
                    }
                }
                .frame(width: width, height: height+exceedHeight, alignment: .bottom)
                .offset(y: openOffset+exceedHeight)
                .offset(y: offset <= -exceedHeight ? -exceedHeight : offset)
                .gesture(DragGesture().updating($gestureOffset, body: {value, state, transaction in
                    state = value.translation.height
                    onChange(state: state)
                }).onEnded({ _ in
                    withAnimation{
                        if offset <= -exceedHeight || offset <= exceedHeight{
                            offset = 0
                        } else {
                            offset = height+exceedHeight
                            showConfirmationDialogView = false
                        }
                    }
                }))
                .onAppear{
                    openOffset = height+exceedHeight
                }
                .onChange(of: showConfirmationDialogView, perform: {_ in
                    withAnimation{
                        if showConfirmationDialogView{
                            openOffset = 0
                            offset = 0
                        }else {
                            openOffset = height+exceedHeight
                            offset = 0
                        }
                    }
                })
            }
            .background(Color.black.opacity(showConfirmationDialogView ? getProgress(height: geometry.size.height/2.5) : 0))
            .ignoresSafeArea()
        }
    }
    
    //Get opacity value for the background
    func getProgress(height: CGFloat)->CGFloat{
        
        let maxOpacity = 0.85
        let maxHeight = height + exceedHeight
        
        if offset <= -exceedHeight{
            return maxOpacity
        }else{
            let progress = ((height - offset) * maxOpacity) / maxHeight
            //print("DEBUG Progress opacity: \(progress)")
            return progress
        }
    }
    func onChange(state: Double){
        DispatchQueue.main.async {
            self.offset = state
            //print("DEBUG offset: \(offset)")
        }
    }
}

//Custom corner for view clipshape
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
        ConfirmationDialogView(showConfirmationDialogView: .constant(true), quantityDesired: .constant(3), showCartView: .constant(true), item: Item(id: 1, designation: "Ecran HMI tactile, TP1200 TFT 12.1 in Coloré", marque: "Siemens", reference: "6AV2124-0MC01-0AX0", JDE: "8765301283", image: "https://www.plc-city.com/shop/368-thickbox_default/6av2124-0mc01-0ax0.jpg", description: "Panneau confort Siemens SIMATIC HMI TP1200 avec écran tactile LCD TFT TFT de12,1 pouces. Il utilise un processeur de type X86. Cette HMI innovante est capable de coordonner et d'arrêter de manière centralisée leurs écrans via PROFI pendant les temps de coupure, pour réduire la consommation d'énergie, par rapport aux panneaux SIMATIC précédents.", price: "3383,16", quantity: 1, createdAt: "2022-06-21T20:50:41.962532Z", updatedAt: "2022-06-21T21:07:39.078499Z"))
            .offset(y:-390)
            .ignoresSafeArea()
    }
}

