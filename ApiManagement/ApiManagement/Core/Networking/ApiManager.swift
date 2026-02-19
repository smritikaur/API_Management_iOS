//
//  ApiManager.swift
//  ApiManagement
//
//  Created by singsys on 26/11/25.
//

import Foundation
import Alamofire

enum ApiManager {
    case searchVideo
}

extension ApiManager {
    var domain: String {
        return base_url
    }
    var url: String {
        var path = ""
        switch self {
        case .searchVideo:
            path = "search?query=animation&per_page=2"
        }
        return domain + path
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchVideo:
            return .get
        }
    }
    
    var needAuthorization: Bool {
        switch self {
        case .searchVideo:
            return true
        }
    }
}

