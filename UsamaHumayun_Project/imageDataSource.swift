//
//  imageDataSource.swift
//  UsamaHumayun_Project
//
//  Created by CTIS Student on 9.06.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import Foundation
import Alamofire

class imageDataSource {
    
    
    
    class func populateFromUnsplash(query: String, completion: @escaping ([String]) -> Void) {
        
        let unsplashAccessKey = "ee0cfec3935724767faea6ea67dbc7e8879dd4884d6f9b32393b95fd57372ac1"
        
        let searchQuery = query.replacingOccurrences(of: " " , with: "_")
        
        let mySearch = searchQuery.replacingOccurrences(of: "'", with: "")
        
        let unsplashUrl = "https://api.unsplash.com/search/photos?page=1&query=" + mySearch + "&client_id=" + unsplashAccessKey
        
        var URLs: [String] = []
        
        AF.request(unsplashUrl, method: .get, encoding:JSONEncoding.default).responseData(completionHandler: { response in
            guard let data = response.data else { return }
            let json = try? JSON(data:data)
            //print(json)
            for (_, subJson) in json!["results"] {
                
                if let url = subJson["urls"]["small"].string {
                    URLs.append(url)
                }
            }
            
            
            DispatchQueue.main.async {
                completion(URLs)
            }
        })
    }

}
