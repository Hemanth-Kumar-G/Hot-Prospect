//
//  ProspectsView.swift
//  HotProspects
//
//  Created by HEMANTH on 04/02/23.
//

import SwiftUI

struct ProspectsView: View {
    
    @EnvironmentObject var prospects : Prospects
    
    enum FilterType {
        case none , contacted , uncontacted
    }
    
    let filterType  : FilterType
    
    var body: some View {
        NavigationView{
            
            Text("People : \(prospects.people.count)")
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.large)
                .toolbar(content: {
                    Button {
                        
                        let prosect  = Prospect()
                        prosect.name = "Hemanth"
                        prosect.emailAddress = "hemanthappu006@gmail.com"
                        prospects.people.append(prosect)
                        
                    } label: {
                        Label("Sacn" , systemImage: "qrcode.viewfinder")
                    }
                })
            
        }
    }
    
    var title : String {
        switch filterType {
        case .none:
            return "EveryOne"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filterType: .none)
            .environmentObject(Prospects())
    }
}
