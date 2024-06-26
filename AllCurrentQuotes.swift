//
//  AllCurrentQuotes.swift
//  cupOfPositivity
//
//  Created by Vanessa Johnson on 4/6/24.
//

import SwiftUI

struct AllCurrentQuotes: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default) private var items: FetchedResults<Quote>
    
    @State private var isDeleteModeActive = false
    @State private var isAlertPresented = false
    
    var body: some View {
        ScrollView {
            ForEach(items, id: \.id) { quoteObject in
                Text("\(quoteObject.quote ?? "Unavailable Quote")")
                    .font(.custom("AirTravelersPersonalUse-BdIt", size: 30))
                    .padding(10)
                    .background(Color(UIColor(red: 235/255, green: 173/255, blue: 199/255, alpha: 1)))
                    .foregroundStyle(Color(UIColor(red: 117/255, green: 36/255, blue: 18/255, alpha: 1)))
                    .clipShape(.rect(cornerRadius: 20))
                    .gesture(deletionGesture(for: quoteObject))
            }
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isAlertPresented = true
                    isDeleteModeActive = true
                }) {
                    Text("Delete")
                }.alert(isPresented: $isAlertPresented) {
                    Alert(title: Text("Delete"), message: Text("If you don't like a quote, delete it! You can delete a quote by swiping it. You will have to press delete for each quote you choose to remove."), dismissButton: .default(Text("Ok")){
                        isDeleteModeActive = true
                    })
                    
                }
            }
        }.background(Color.clear)
    }
    
    private func deletionGesture(for quote: Quote) -> some Gesture {
        DragGesture()
            .onEnded { _ in
                deleteQuote(quote)
            }
    }
    
    private func deleteQuote(_ quote: Quote) {
        guard isDeleteModeActive else { return }
        viewContext.delete(quote)
        
        do {
            try viewContext.save()
            isDeleteModeActive = false
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}


#Preview {
    AllCurrentQuotes()
}
