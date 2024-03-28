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
    
    var body: some View {
        NavigationView {
        GeometryReader{ geometry in
            ZStack {
                Image("cupOfPos").resizable().aspectRatio(contentMode: .fill).frame(minWidth: 0, maxWidth: .infinity).edgesIgnoringSafeArea(.all)
                Text("Cup of Positivity").position(x:geometry.size.width/2, y:geometry.size.height/12).font(.custom("AirTravelersPersonalUse-BdIt", size: 50)).foregroundColor(Color(UIColor(red: 117/255, green: 36/255, blue: 18/255, alpha: 1)))
                HStack{
                    Spacer()
                    TextField("Enter a new quote to add", text: $newQuoteText).font(.custom("AirTravelersPersonalUse-BdIt", size: 20))
                    Button(action: {
                        addPositivity()
                        showMessage = true
                    }, label: {
                        Text("Add new Quote").font(.custom("AirTravelersPersonalUse-BdIt", size: 20)).foregroundColor(Color(UIColor(red: 117/255, green: 36/255, blue: 18/255, alpha: 1)))
                    })
                    Spacer()
                    Spacer()
                }.position(x:geometry.size.width/2, y:geometry.size.height/1.05)
                
                if showMessage {
                    Text("Quote has been added").font(.custom("AirTravelersPersonalUse-BdIt", size: 20)).foregroundColor(Color(UIColor(red: 117/255, green: 36/255, blue: 18/255, alpha: 1))).position(x:geometry.size.width/2, y:geometry.size.height/1.01)
                }
            }.onAppear(){
                notif()
            }
        }
        }.navigationBarBackButtonHidden(true)
    }
    
    func addPositivity(){
        withAnimation{
            let newQuote = Quote(context: viewContext)
            newQuote.quote = newQuoteText
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
//        var dateComponents = DateComponents()
//        dateComponents.calendar = Calendar.current
//        dateComponents.hour = 11
//        dateComponents.minute = 04
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
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
