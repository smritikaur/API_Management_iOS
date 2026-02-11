//
//  MainTabView.swift
//  ApiManagement
//
//  Created by singsys on 28/10/25.
//

import SwiftUI

struct MainTabView: View {
    @State var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeTab(buttonText: "Get Pexels Data", navigationTitle: "Home")
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            DownloadsTab(maintext: "Downloads")
                .tabItem {
                    Image(systemName: "arrow.down.circle.fill")
                    Text("Downloads")
                }
                .tag(1)
        }
    }
}
