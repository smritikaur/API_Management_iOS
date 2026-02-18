//
//  VideoItem.swift
//  ApiManagement
//
//  Created by singsys on 13/02/26.
//
import Foundation

struct VideoItem: Identifiable, Hashable {
    let id = UUID().uuidString
    let name: String
    let link: String
    let videoPicture: String
}
