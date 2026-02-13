//
//  HomeTabViewModel.swift
//  ApiManagement
//
//  Created by singsys on 11/02/26.
//

import Foundation
import Combine
import Alamofire

class HomeTabViewModel: ObservableObject {
    
    @Published var videoFiles: [VideoFile] = []
    @Published var videoNames: [String] = []
    @Published var videos: [VideoItem] = []
    let baseURL = "https://www.pexels.com/video/"
    
    func fetchVideos(){
        CommonService.requestFromWebService(
            ApiManager.searchVideo,
            parameters: [:]) { data, error, code in
                var items: [VideoItem] = []
                if let data = data {
                    for videoData in data.videos {
                        let videoUrl = videoData.url
                        guard
                            videoUrl.hasPrefix(self.baseURL),
                            let lastDashIndex = videoUrl.lastIndex(of: "-") else {
                            continue
                        }
                        
                        let startIndex = videoUrl.index(videoUrl.startIndex, offsetBy: self.baseURL.count)
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
    
    func copyFileLocation() { } 
    func renameFile() { }
    func deleteFile() { }
    func downloadFile() {}
    
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
