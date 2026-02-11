//
//  AlamofireService.swift
//  ApiManagement
//
//  Created by singsys on 26/11/25.
//

import Foundation
import Alamofire

class CommonService {
    class func configHeader(_ needAuthorization: Bool) -> HTTPHeaders?{
        var headers: HTTPHeaders? = [
            "Content-Type": "application/json", "Accept": "application/json"
        ]
        if needAuthorization {
            //            if UserDefaults.userToken != "" {
            headers = [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "vTDWL4HY9oIt9ghODvJn0cuv75dU4PAiCUDLSJUPTl4zdDmfnQQtiGaN",
            ]
            //            }
        }
        return headers
        
    }
    
    class func requestFromWebService(
        _ apiManager: ApiManager,
        parameters: [String: Any]?,
        completion: @escaping (_ data: PexelsVideoSearchModel?, _ error: String?, _ code: Int?) -> Void
    ) {
        guard let headers = configHeader(apiManager.needAuthorization) else {
            completion(nil, "Cannot get user authorisation token.", nil)
            return
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601   // IMPORTANT for date_created
        
        AF.request(
            apiManager.url,
            method: apiManager.method,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseDecodable(of: PexelsVideoSearchModel.self, decoder: decoder) { response in
            
            print("API url = \(apiManager.url)")
            
            switch response.result {
            case .success(let welcomeModel):
                print("success block executed")
                completion(welcomeModel, nil, response.response?.statusCode)
                
            case .failure(let error):
                print("failure block executed")
                let statusCode = response.response?.statusCode
                completion(nil, error.localizedDescription, statusCode)
            }
        }
    }
}
