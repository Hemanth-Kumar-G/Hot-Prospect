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
    fileprivate(set) var isContacted = false
}

@MainActor class Prospects : ObservableObject {
    @Published  var people : [Prospect]
    let SAVE_KEY = "SavedData"
    init() {
        
        if let data = UserDefaults.standard.data(forKey: SAVE_KEY){
            if let decode = try? JSONDecoder().decode([Prospect].self, from: data){
                people = decode
                return
            }
        }
        // no saved data!
        people = []
    }
    
    
    private func save(){
        if let encode = try? JSONEncoder().encode(people){
            UserDefaults.standard.set(encode, forKey: SAVE_KEY)
        }
    }
    
    func add(_ prospect : Prospect){
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}
