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
    @State var pexelsVideoSearchData: PexelsVideoSearchModel?
    @State private var videoFiles: [VideoFile] = []
    @State private var videoNames: [String] = []
    @State private var videos: [VideoItem] = []
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                List {
                    ForEach(videos){ video in
                        HStack {
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
                                                return length * 0.3
                                            } else {
                                                return length * 0.6
                                            }
                                        }
                                } else {
                                    // Fallback on earlier versions
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                        .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.2)
                                }
                            } placeholder: {
                                ProgressView().progressViewStyle(.circular)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            
                            VStack(alignment: .leading) {
                                Text(video.name)
                                    .font(.headline)
                                Text(video.link)
//                                Text(video.videoPicture)
                            }
                            .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.15)
                            .clipped()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .clipped()
                    }
                }
                .background(Color.brown)
                .navigationTitle(navigationTitle)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Button(action: {
                        buttonTap()
                    }, label: {
                        Image(systemName: "arrow.down.circle")
                    }),
                    trailing: Image(systemName: "heart.circle.fill")
                )
            }
        }
    }
    
    func buttonTap(){
        CommonService.requestFromWebService(
            ApiManager.searchVideo,
            parameters: [:]) { data, error, code in
                let baseURL = "https://www.pexels.com/video/"
                var items: [VideoItem] = []
                if let data = data {
                    for videoData in data.videos {
                        let videoUrl = videoData.url
                        guard
                            videoUrl.hasPrefix(baseURL),
                            let lastDashIndex = videoUrl.lastIndex(of: "-") else {
                            continue
                        }
                        
                        let startIndex = videoUrl.index(videoUrl.startIndex, offsetBy: baseURL.count)
                        let videoTitle = String(videoUrl[startIndex..<lastDashIndex])
                        
                        //MARK: VideoLink extraction
                        
                        let videoFiles = videoData.videoFiles
                        guard let videoLinks = videoFiles.first(where: {
                            $0.quality == "hd" &&
                            $0.fileType == "video/mp4" &&
                            $0.width == 1280 &&
                            $0.height == 720
                        }) else {
                            print("executed else of guard")
                            continue
                        }
                        
                        //MARK: ImageUrl extraction
                        guard let thumbnail = videoData.videoPictures.first else { continue }
                        
                        let videoItem = VideoItem(name: videoTitle, link: videoLinks.link, videoPicture: thumbnail.picture)
                        items.append(videoItem)
                    }
                    
                    DispatchQueue.main.async {
                        self.videos = items
                    }
                } else if let error = error {
                    print("error = \(error)")
                }
            }
    }
    
    func getDataFromPexels(){
        AF.request("https://api.pexels.com/videos/search?query=space&per_page=2")
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseString { response in
                switch response.result {
                case .success:
                    print("Validation successful")
                    print(response.result)
                case let .failure(error):
                    print(error)
                }
            }
    }
}
