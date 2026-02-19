//
//  DownloadService.swift
//  ApiManagement
//
//  Created by singsys on 13/02/26.
//


/***
 // MARK: Link
 Ref: How to download and save video in device storage in swift? https://thatswiftguy.medium.com/how-to-download-save-the-video-in-device-storage-in-swift-a1129aecd736
 // MARK: Full Download Flow Summary
 1. downloadVideo() called
 2. URLSession starts download
 3. didWriteData updates progress
 4. didFinishDownloadingTo called when done
 5. File saved to Documents
 6. Album checked/created
 7.Video saved to Photos album
 */
import Foundation
import Photos
import AVFoundation
import Combine

enum DownloadAlertType: String, Identifiable {
    case downloaded
    case alreadyDownloaded
    var id: String { rawValue }
}

class DownloadViewModel: NSObject, ObservableObject, URLSessionDownloadDelegate {
    @Published var progress: [String: Float] = [:]
    @Published var isDownloadComplete: [String: Bool] = [:]
    @Published var activeAlert: DownloadAlertType?
    
    ///starts downloading a video from a URL
    func downloadVideo(url: URL, videoItemId: String) {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil) //Sets self as the delegate so progress + completion methods will be called.
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else { //we dont need this datatask we could actually directly start the downloadTask as well
                return
            }
            let downloadTask = session.downloadTask(with: url) //actual download task
            downloadTask.taskDescription = videoItemId
            downloadTask.resume()
        }
        task.resume()
    }
    
    ///didFinishDownloadingTo called when the download completes;  location is a temporary file URL where iOS stores the downloaded file.
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        /// Step 1 - Convert temp file into data (means reads the downloaded file into memory)
        guard let data = try? Data(contentsOf: location) else {
            return
        }
        /// Step 2 - Get Document Directory (means gets your app's Document folder)
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        /// Step 3 - Cretae destination file path (Final save location - Documents/myVideo.mp4)
        let destinationURL = documentsURL.appendingPathComponent("myVideo.mp4")
        do {
            /// Step 4 - Save file (Writes the video permanently)
            try data.write(to: destinationURL)
            /// Step 5 - Save to Photos album
            saveVideoToAlbum(videoURL: destinationURL, albumName: "MyAlbum")
        } catch {
            print("Error saving file:", error)
        }
    }
    /// called continuously while downloading
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let videoItemId = downloadTask.taskDescription else { return }
        print(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        DispatchQueue.main.async { [weak self] in
            /// Calculates progress (Eg: Written : 50 MB, Expected: 100MB, Progress: 0.5) and updates UI on main thread
            print("progress123 = \(progress)")
            print("videoItemId123 = \(videoItemId)")
            self?.progress[videoItemId] = progress
            if progress >= 1.0 {
                self?.isDownloadComplete[videoItemId] = true
            }
        }
    }
    /// Checks if album exists; If yes - saves video; If no - create album - then save video
    /// Older version - Check → Maybe wrong → Create duplicate - caused duplicate albums
//    private func saveVideoToAlbum(videoURL: URL, albumName: String) {
//        /// STEP 1: Check if album exists
//        if albumExists(albumName: albumName) {
//            let fetchOptions = PHFetchOptions()
//            fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
//            
//            
//            let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: fetchOptions)
//            if let album = collection.firstObject {
//                /// STEP 3 - Save video into the album
//                saveVideo(videoURL: videoURL, to: album)
//            }
//        } else {
//            var albumPlaceholder: PHObjectPlaceholder?
//            PHPhotoLibrary.shared().performChanges({
//                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
//                albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
//            }, completionHandler: { success, error in
//                if success {
//                    guard let albumPlaceholder = albumPlaceholder else { return }
//                    let collectionFetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumPlaceholder.localIdentifier], options: nil)
//                    guard let album = collectionFetchResult.firstObject else { return }
//                    self.saveVideo(videoURL: videoURL, to: album)
//                } else {
//                    print("Error creating album: \(error?.localizedDescription ?? "")")
//                }
//            })
//        }
//    }
    ///Fetch → If exists use → Else create - this tighter version prevents videos from going to differrent versions.
    private func saveVideoToAlbum(videoURL: URL, albumName: String) {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        
        // IMPORTANT: Use .albumRegular
        let collection = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .albumRegular,
            options: fetchOptions
        )
        
        if let album = collection.firstObject {
            // Album exists → reuse it
            saveVideo(videoURL: videoURL, to: album)
        } else {
            // Album does not exist → create once
            PHPhotoLibrary.shared().performChanges({
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
            }) { success, error in
                if success {
                    // Fetch the newly created album
                    let fetchResult = PHAssetCollection.fetchAssetCollections(
                        with: .album,
                        subtype: .albumRegular,
                        options: fetchOptions
                    )
                    if let newAlbum = fetchResult.firstObject {
                        self.saveVideo(videoURL: videoURL, to: newAlbum)
                    }
                } else {
                    print("Error creating album:", error?.localizedDescription ?? "")
                }
            }
        }
    }
    /// Searches Photos for an album with that title.
//    private func albumExists(albumName: String) -> Bool {
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
//        /// STEP 2 -  Fetch album (Find albums in Photos)
//        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
//        return collection.firstObject != nil
//    }

    /// Saves video in the Photos app
    private func saveVideo(videoURL: URL, to album: PHAssetCollection) {
        /// Create video asset (This adds videos to Photos library)
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
            /// If album doesn't exist the creates the album then fetches the created album and then saves video
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
            let enumeration: NSArray = [assetChangeRequest!.placeholderForCreatedAsset!]
            /// Add it to album (Links the video to the specific Album)
            albumChangeRequest?.addAssets(enumeration)
        }, completionHandler: { success, error in
            if success {
                print("Successfully saved video to album")
            } else {
                print("Error saving video to album: \(error?.localizedDescription ?? "")")
            }
        })
    }
}
