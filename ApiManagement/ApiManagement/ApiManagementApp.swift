//
//  ApiManagementApp.swift
//  ApiManagement
//
//  Created by singsys on 19/10/25.
//

import SwiftUI
import SwiftData

@available(iOS 17.0, *)
@main // @main attribute describes the entry point of the App.
struct ApiManagementApp: App { //ApiManagementApp struct conforms to protocol App that describes the content and behaviour of the app.
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var downloadViewModel = DownloadViewModel()
    var body: some Scene { //body computed property that defines content and behaviour of the App. Body conforms to protocol Scene (which can be thought of as a part of UI or container life cycle managed by the system.)
        WindowGroup {
            ContentView()
                .onChange(of: scenePhase) { oldPhase, newPhase in
                    switch newPhase {
                    case .background:
                        print("SchenePhase: Background from \(oldPhase)")
                    case .inactive:
                        print("SchenePhase: Inactive from \(oldPhase)")
                    case .active:
                        print("SchenePhase: Active/Foreground from \(oldPhase)")
                        downloadViewModel.restoreDownloads()
                    @unknown default:
                        print("SchenePhase: Unknown scene phase \(newPhase) from \(oldPhase)")
                    }
                }
        }
        .modelContainer(for: [DownloadedVideoDataModel.self])
    }
}
