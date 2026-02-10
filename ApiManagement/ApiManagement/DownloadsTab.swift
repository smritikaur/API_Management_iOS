//
//  DownloadsTab.swift
//  ApiManagement
//
//  Created by singsys on 28/10/25.
//

import SwiftUI

struct DownloadsTab: View {
    let maintext: String
    var body: some View {
        NavigationView {
            Text(maintext)
                .navigationTitle(maintext)
                .navigationBarTitleDisplayMode(.inline)
                .foregroundColor(Color.white)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(colors: [Color.red, Color.blue ], startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: 100, height: 100)
                        .shadow(color: Color.gray, radius: 10, x: 0.0, y: 10.0)
                        .overlay(
                            Circle()
                                .fill(Color.cyan)
                                .frame(width: 35, height: 35)
                                .overlay(
                                    Text("5")
                                        .font(.headline)
                                        .foregroundColor(Color.white)
                                    ,alignment: .center
                                )
                                .shadow(color: Color.gray, radius: 5, x: 5, y: 10)
                            ,alignment: .bottomTrailing
                        )
                    
                )
        }
    }
}
