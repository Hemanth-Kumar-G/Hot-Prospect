//
//  ProspectsView.swift
//  HotProspects
//
//  Created by HEMANTH on 04/02/23.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    
    @EnvironmentObject var prospects : Prospects
    
    enum FilterType {
        case none , contacted , uncontacted
    }
    
    let filterType  : FilterType
    
    @State private var isShowingScanner = false
    
    var body: some View {
        NavigationView{
            List{
                ForEach(filteredProspects){ prospect in
                    VStack(alignment: .leading){
                        
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailAddress)
                            .font(.headline)
                        
                    }
                    .swipeActions {
                        if prospect.isContacted {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                            
                            Button {
                                addNotification(for: prospect)
                            } label: {
                                Label("Remind Me", systemImage: "bell")
                            }
                            .tint(.orange)
                        }
                    }
                }
                
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar(content: {
                Button {
                    isShowingScanner = true
                } label: {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
            })
            .sheet(isPresented: $isShowingScanner, content: {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Hemanth \n hemanthappu006@gmail.com", completion: handleScan)
            })
            
        }
    }
    
    func handleScan(result : Result<ScanResult,ScanError>) -> Void {
        isShowingScanner = false
        switch result {
            
        case .success(let result) :
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            prospects.add(person)
            
        case .failure(let error) :
            print("Scanning failed: \(error.localizedDescription)")
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
    
    
    var filteredProspects : [Prospect]{
        switch filterType {
        case .none :
            return prospects.people
            
        case .contacted :
            return prospects.people.filter { $0.isContacted }
            
        case .uncontacted :
            return prospects.people.filter { !$0.isContacted }
        }
    }
    
    private func addNotification(for prospect:Prospect){
        
        let current = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = prospect.name
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            //            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            current.add(request)
        }
        
        current.getNotificationSettings{ settings in
            
            if  settings.authorizationStatus == .authorized {
                addRequest()
            } else  {
                current.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh!")
                    }
                }
            }
            
            
        }
        
    }
    
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filterType: .none)
            .environmentObject(Prospects())
    }
}
