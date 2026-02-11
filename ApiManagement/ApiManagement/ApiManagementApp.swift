//
//  ApiManagementApp.swift
//  ApiManagement
//
//  Created by singsys on 19/10/25.
//

import SwiftUI

@main // @main attribute describes the entry point of the App.
struct ApiManagementApp: App { //ApiManagementApp struct conforms to protocol App that describes the content and behaviour of the app.
    var body: some Scene { //body computed property that defines content and behaviour of the App. Body conforms to protocol Scene (which can be thought of as a part of UI or container life cycle managed by the system.)
        WindowGroup {
            ContentView()
        }
    }
}
