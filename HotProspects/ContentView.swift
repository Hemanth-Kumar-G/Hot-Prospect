//
//  ContentView.swift
//  HotProspects
//
//  Created by HEMANTH on 04/02/23.
//

import SwiftUI

struct ContentView: View {
     
     @StateObject var propects  = Prospects()
    
    
    var body: some View {
        
        TabView {
          
            ProspectsView(filterType: .none)
                .tabItem{
                    Label("EveryOne", systemImage:"person.3")
                }
            
            ProspectsView(filterType: .contacted)
                .tabItem{
                    Label("Contacted", systemImage:"checkmark.circle")
                }
            
            ProspectsView(filterType: .uncontacted)
                .tabItem{
                    Label("Uncontacted", systemImage:"questionmark.diamond")
                }
            
            MeView()
                .tabItem{
                    Label("Me", systemImage:"person.crop.square")
                }
            
        }
        .environmentObject(propects)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
