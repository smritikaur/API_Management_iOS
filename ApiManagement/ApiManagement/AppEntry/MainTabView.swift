//
//  MainTabView.swift
//  ApiManagement
//
//  Created by singsys on 28/10/25.
//

import SwiftUI

@available(iOS 17, *)
struct MainTabView: View {
    @State var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeTabView(buttonText: "get_pexels_data", navigationTitle: HomeStrings.homeNavigationTitle) //localizable strings
                .tabItem {
                    Image(systemName: "house.fill")
                    Text(MainTabStrings.homeNavigationTitle)
                }
                .tag(0)
            DownloadsTab(maintext: MainTabStrings.downloads)
                .tabItem {
                    Image(systemName: "arrow.down.circle.fill")
                    Text(MainTabStrings.downloads)
                }
                .tag(1)
        }
    }
}
