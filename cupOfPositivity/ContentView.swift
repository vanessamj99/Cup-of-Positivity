//
//  ContentView.swift
//  cupOfPositivity
//
//  Created by Vanessa Johnson on 2/17/24.
//

import SwiftUI

struct ContentView: View {
    @State private var moving = false

    
    var body: some View {
        NavigationView {
            GeometryReader{ geometry in
                ZStack{
                    Image("cupOfPos").resizable().aspectRatio(contentMode: .fill).frame(minWidth: 0, maxWidth: .infinity).edgesIgnoringSafeArea(.all)
                    Text("Cup of Positivity").position(x:geometry.size.width/2, y:geometry.size.height/12).font(.custom("AirTravelersPersonalUse-BdIt", size: 50)).foregroundColor(Color(UIColor(red: 117/255, green: 36/255, blue: 18/255, alpha: 1)))
                    NavigationLink(destination: Notifications().navigationBarBackButtonHidden(true)){
                            Image("arrow").resizable()
                                .offset(x: moving ? 0 : 40)
                                .animation(.interpolatingSpring(stiffness: 60, damping: 14).repeatForever(autoreverses: true), value: moving)
                        .frame(width: 100,height: 100,alignment: .bottomTrailing)
                            .position(x: geometry.size.width/1.3, y: geometry.size.height/1.1)
                        
                    }
                }
                
            }.onAppear(){
                self.moving.toggle()
            }
        }
    
      
    }
    
}


#Preview {
    ContentView()
}
