//
//  Notifications.swift
//  cupOfPositivity
//
//  Created by Vanessa Johnson on 3/2/24.
//

import SwiftUI
import CoreData

struct Notifications: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default) private var items: FetchedResults<Quote>
    
    @State private var newQuoteText = ""
    @State private var showMessage = false
    @State private var enteringANewQuote = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("cupOfPos")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                
                Text("Cup of Positivity")
                    .position(x: UIScreen.main.bounds.width / 2, y: 60)
                    .font(.custom("AirTravelersPersonalUse-BdIt", size: 50))
                    .foregroundColor(Color(UIColor(red: 117/255, green: 36/255, blue: 18/255, alpha: 1)))
                
                if enteringANewQuote {
                    HStack {
                        Spacer()
                        TextField("Enter a new quote to add", text: $newQuoteText)
                            .font(.custom("AirTravelersPersonalUse-BdIt", size: 20))
                        
                        Button(action: {
                            addPositivity()
                            showMessage = true
                        }) {
                            Text("Add new Quote")
                                .font(.custom("AirTravelersPersonalUse-BdIt", size: 20))
                                .foregroundColor(Color(UIColor(red: 117/255, green: 36/255, blue: 18/255, alpha: 1)))
                        }.alert(isPresented: $showMessage) {
                            Alert(title: Text("Success!"), message: Text("Quote has been added"), dismissButton: .default(Text("Thanks!")){
                                enteringANewQuote = false
                            })
                            
                        }
                        Spacer()
                    }
                    .padding()
                    .position(x: 200, y: 720)
                } else {
                    HStack {
                        Button(action: {
                            enteringANewQuote = true
                        }
                               , label: {
                            Text("I want to add a quote")
                                .font(.custom("AirTravelersPersonalUse-BdIt", size: 18))
                                .padding()
                                .background(Color.pink)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .foregroundColor(Color.black)
                        })
                        
                        
                        NavigationLink(destination: FeedOfQuotes()) {
                            Text("Current Quotes")
                                .font(.custom("AirTravelersPersonalUse-BdIt", size: 18))
                                .padding()
                                .background(Color.pink)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .foregroundColor(Color.black)
                        }
                    }
                    .padding()
                    .position(x: 200, y: 720)
                }
                
            }
            .onAppear {
                notif()
            }
        }
    }
    
    func addPositivity(){
        withAnimation{
            let newQuote = Quote(context: viewContext)
            newQuote.quote = newQuoteText
            newQuote.id = UUID()
            do {
                try viewContext.save()
            }
            catch{
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError)")
            }
        }
        
    }
    func notif() {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: contentInfo(), trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        notificationCenter.requestAuthorization(options: options) { success, error in
            DispatchQueue.main.async{
                if success {
                    notificationCenter.add(request)
                }
            }
            
        }
    }
    
    func contentInfo() -> UNMutableNotificationContent {
        let randomInt = Int(arc4random_uniform(UInt32(items.count)))
        let content = UNMutableNotificationContent()
        content.title = "A Little Bit of Positivity"
        content.body = "\(items[Int(randomInt)].quote ?? "I hope you have an amazing day!")"
        return content
    }
    
}



#Preview {
    Notifications().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
