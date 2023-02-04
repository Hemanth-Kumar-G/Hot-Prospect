//
//  Prospect.swift
//  HotProspects
//
//  Created by HEMANTH on 04/02/23.
//

import Foundation

class Prospect :Identifiable ,Codable {
    var id : UUID =  UUID()
    var name : String = ""
    var emailAddress : String = ""
    var isContracted = false
}

@MainActor class Prospects : ObservableObject {
    @Published  var people : [Prospect]
    
    init() { 
        people = []
    }
}
