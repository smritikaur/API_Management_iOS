//
//  MainTabView.swift
//  ApiManagement
//
//  Created by singsys on 28/10/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .tabItem {
                    Text("Home")
                }
            Text("Downloads")
                .tabItem {
                    Text("Downloads")
                }
        }
    }
}
