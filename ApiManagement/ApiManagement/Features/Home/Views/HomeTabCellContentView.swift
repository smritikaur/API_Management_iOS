//
//  HomeTabCellContentView.swift
//  ApiManagement
//
//  Created by singsys on 18/02/26.
//
import SwiftUI
import SwiftData

@available(iOS 17, *)
struct CellContent: View {
    let homeViewModel: HomeTabViewModel
    @ObservedObject var viewModel: DownloadViewModel
    let video: VideoItem
    let geometry: GeometryProxy
    @Environment(\.modelContext) var modelContext
    @Query var dowloadedVideoDataModel: [DownloadedVideoDataModel]
    private var currentVideoData: DownloadedVideoDataModel? {
        dowloadedVideoDataModel.first(where: { $0.videoLink == video.link })
    }
    
    var body: some View {
        HStack(alignment: .top) {
            ZStack {
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
                } .onTapGesture {
                    print("Tapped cell")
                    if let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
                        let dbURL = appSupport.appendingPathComponent("default.store")
                        print("SwiftData DB Path:")
                        print(dbURL.path)
                    }
                    if let progress = currentVideoData?.progress {
                        if progress >= 1.0 {
                            viewModel.activeAlert = .alreadyDownloaded
                            print("Video already downloaded.")
                        } else {
                            viewModel.downloadVideo(url: URL(string: video.link)!, videoItemId: video.id)
                        }
                    } else {
                        viewModel.downloadVideo(url: URL(string: video.link)!, videoItemId: video.id)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
                if let progress = currentVideoData?.progress {
                    if progress >= 1.0 {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 20))
                            .foregroundColor(Color.black.opacity(0.8))
                            .padding(6)
                            .background(Color.white.opacity(0.6))
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                } else {
                    Image(systemName: "arrow.down.circle")
                        .font(.system(size: 20))
                        .foregroundColor(Color.black.opacity(0.8))
                        .padding(6)
                        .background(Color.white.opacity(0.6))
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                if let liveProgress = viewModel.progress[video.id] {
                    if liveProgress < 1.0 {
                        ProgressIndicator(progress: CGFloat(liveProgress))
                            .frame(width: 20, height: 20)
                            .padding(6)
                            .background(Color.white.opacity(0.6))
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                }
            }
            
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
                Button("cancel_download") {
                    viewModel.cancelDownload(task: viewModel.downloadTask)
                }
                Button("resume_download"){
                    viewModel.resumeDownload(resumeData: viewModel.resumeData, urlSession: viewModel.urlSession, videoItemId: video.id)
                }
            } label: {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
            }
            .padding(.top, 9)
            .compositingGroup()     // fixes _UIReparentingView warning
        }
        .frame(maxWidth: .infinity)
        .onChange(of: viewModel.isDownloadComplete[video.id]) { _, isComplete in
            if let isComplete = isComplete, isComplete {
                if let progress = viewModel.progress[video.id] {
                    let newDownloadVideoDataModel = DownloadedVideoDataModel(videoId: video.id, progress: progress, videoLink: video.link)
                    print("called 123")
                    viewModel.activeAlert = .downloaded
                    /// right now inserting only those videos in local db whose progress is equal to 1.0, that is, has been downloaded.
                    modelContext.insert(newDownloadVideoDataModel)
                }
            }
        }
        .alert(item: $viewModel.activeAlert) { alertType in
            switch alertType {
            case .downloaded:
                return Alert(title: Text("Video Downloaded"))
            case .alreadyDownloaded:
                return Alert(title: Text("Video Already Downloaded"))
            }
        }
    }
}
