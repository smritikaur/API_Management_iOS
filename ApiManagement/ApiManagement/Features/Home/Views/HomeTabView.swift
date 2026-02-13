//
//  HomeTab.swift
//  ApiManagement
//
//  Created by singsys on 28/10/25.
//

import SwiftUI
import Alamofire

struct HomeTab: View {
    let buttonText: String
    let navigationTitle: String
    @StateObject var homeViewModel: HomeTabViewModel = HomeTabViewModel()
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                List {
                    ForEach(homeViewModel.videos){ video in
                        HStack(alignment: .top) {
                            AsyncImage(url: URL(string: video.videoPicture), scale: 1)
                            { image in
                                if #available(iOS 17.0, *) {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                        .containerRelativeFrame([.horizontal, .vertical]) { length, axis in
                                            if axis == .horizontal {
                                                return length * 0.27
                                            } else {
                                                return length * 0.7
                                            }
                                        }
                                } else {
                                    // Fallback on earlier versions
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                        .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.3)
                                }
                            } placeholder: {
                                ProgressView().progressViewStyle(.circular)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            
                            VStack(alignment: .leading) {
                                Text(video.name)
                                    .font(.system(size: 17, weight: .bold, design: .rounded))
                                Text(video.link)
                                    .font(.system(size: 12, weight: .regular, design: .rounded))
                                    .lineLimit(2)
//                                Text(video.videoPicture)
                            }
                            .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.11, alignment: .top)
                            
                            Menu {
                                Button(HomeStrings.copyFileLocation, action: homeViewModel.copyFileLocation) //eg using Strings.swift
                                Button("rename_file", action: homeViewModel.renameFile) //eg using localizable.strigs file
                                Button("download_file", action: homeViewModel.downloadFile)
                                Button("delete_file", action: homeViewModel.deleteFile)
                            } label: {
                                Image(systemName: "ellipsis")
                                    .rotationEffect(.degrees(90))
                            }
                            .padding(.top, 9)
                        }
                        .frame(maxWidth: .infinity)
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
