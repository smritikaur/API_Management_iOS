//
//  DownloadedVideoDataModel.swift
//  ApiManagement
//
//  Created by singsys on 18/02/26.
//  Local db
import SwiftData

@available(iOS 17, *)
@Model
class DownloadedVideoDataModel {
    var videoId: String
    var progress: Float
    @Attribute(.unique) var videoLink: String
    
    init(videoId: String, progress: Float, videoLink: String) {
        self.videoId = videoId
        self.progress = progress
        self.videoLink = videoLink
    }
}
