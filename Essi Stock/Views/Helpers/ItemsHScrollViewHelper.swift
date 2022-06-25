//
//  ItemsHScrollViewHelper.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 25/06/2022.
//

import SwiftUI

struct ItemsHScrollViewHelper: View {
    
   var title: String
    let items: [Item]
    
    init(title:String, items: [Item]){
        self.title = title
        self.items = items
    }
    
    var body: some View {
        VStack{
                HStack{
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Text("Tout")
                            .foregroundColor(Color("Orange Color"))
                    })
                }
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing:30){
                        ForEach(items){item in
                            VStack(alignment:.leading, spacing:4){
                                AsyncImage(url: URL(string: item.image),
                                           content: { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 130, height: 130)
                                        .cornerRadius(20)
                                },placeholder: {
                                    Color.gray.opacity(0.7)
                                        .frame(width: 130, height: 130)
                                        .cornerRadius(20)
                                })
                                Text(item.designation)
                                    .font(.caption.bold())
                                    .lineLimit(2)
                                Text(item.marque)
                                    .font(.caption2)
                                Text(item.reference)
                                    .font(.caption2)
                                    .foregroundColor(Color.gray)
                                
                            }
                            .frame(width: 130)
                        }
                    }.padding(.horizontal)
                }
            }
        }
    }


struct ItemsHScrollViewHelper_Previews: PreviewProvider {
    static var previews: some View {
        ItemsHScrollViewHelper(title: "Last object", items: [Item(id: 1, designation: "Ecran HMI tactile, TP1200 TFT 12.1 in Coloré", marque: "Siemens", reference: "6AV2124-0MC01-0AX0", JDE: "8765301283", image: "https://www.plc-city.com/shop/368-thickbox_default/6av2124-0mc01-0ax0.jpg", description: "Panneau confort Siemens SIMATIC HMI TP1200 avec écran tactile LCD TFT TFT de12,1 pouces. Il utilise un processeur de type X86. Cette HMI innovante est capable de coordonner et d'arrêter de manière centralisée leurs écrans via PROFI pendant les temps de coupure, pour réduire la consommation d'énergie, par rapport aux panneaux SIMATIC précédents.", price: "3383,16", quantity: 1, createdAt: "2022-06-21T20:50:41.962532Z", updatedAt: "2022-06-21T21:07:39.078499Z"), Item(id: 2, designation: "Convertisseur de médias Ethernet", marque: "Brainboxes", reference: "ED-008", JDE: "123933911", image: "https://fr.farnell.com/productimages/large/fr_FR/2383209-40.jpg", description: "Panneau tactile Schneider Electric Magelis GTO HMI\r\n\r\nLes panneaux tactiles Schneider Electric Magelis GTO HMI sont le résultat final d'une ingénierie innovante, représentant la clé de l'automatisation intégrée totale. Les tâches HMI (interface homme-machine) de plus grandes complexités sont la fonction principale du module. Fournir aux utilisateurs la solution de commodité et d'automatisation ultime pour une multitude d'applications.", price: "120,43", quantity: 2, createdAt: "2022-06-24T20:15:52.832875Z", updatedAt: "2022-06-24T20:15:52.832986Z")])
    }
}

