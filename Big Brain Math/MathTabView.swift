//
//  ContentView.swift
//  Big Brain Math
//
//  Created by ParkingPal on 9/21/21.
//

import SwiftUI

struct MathTabView: View {
    
    init() {
        UITabBar.appearance().backgroundColor = .tabBarPrimary
    }
    
    var body: some View {
        TabView {
            PlayView()
                .tabItem {
                    Image(systemName: "gamecontroller.fill")
                    Text("Play Games")
                }
            
            StatsView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Progress")
                }
            
            AccountView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .accentColor(.brandSecondary)
        .onAppear() {
            if #available(iOS 15.0, *) {
                let appearance = UITabBarAppearance()
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MathTabView()
    }
}
