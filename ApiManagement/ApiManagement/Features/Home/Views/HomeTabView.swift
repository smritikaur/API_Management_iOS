//
//  HomeTab.swift
//  ApiManagement
//
//  Created by singsys on 28/10/25.
//

import SwiftUI

@available(iOS 17, *)
struct HomeTabView: View {
    @StateObject var homeViewModel: HomeTabViewModel = HomeTabViewModel()
    let buttonText: String
    let navigationTitle: String
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                List {
                    ForEach(homeViewModel.videos){ video in
                        CellContent(homeViewModel: homeViewModel, video: video, geometry: geometry)
                    }
                }
                .navigationTitle(navigationTitle)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Button(action: {
                        homeViewModel.fetchVideos()
                    }, label: {
                        Image(systemName: "arrow.down.circle")
                    }),
                    trailing: Image(systemName: "heart.circle.fill")
                )
            }
        }
    }
}
