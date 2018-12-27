//
//  RequestManager.swift
//  Atlas
//
//  Created by Pavel Belevtsev on 12/27/18.
//  Copyright © 2018 Pavel Belevtsev. All rights reserved.
//

import UIKit
import AFNetworking

class RequestManager: NSObject {
    
    static let shared = RequestManager(baseURL: ConfigManager.remoteURL)
    
    let baseURL: String
    let manager = AFHTTPSessionManager()
    
    init(baseURL: String) {
        self.baseURL = baseURL
        
        manager.requestSerializer = AFJSONRequestSerializer();
        manager.responseSerializer = AFJSONResponseSerializer();
    }
    
    func searchByRegion(_ type : String!, _ region : String!, _ completionHandler: @escaping (_ contries: [[String : Any]]?, _ error: Error?) -> ()) {
        
        manager.get("\(baseURL)\(type!)/\(region!)", parameters: nil, progress: { (progress) in
            
        }, success: { (operation, responseObject) in
            if let result = responseObject as? [[String : Any]] {
                completionHandler(result, nil)
            } else {
                completionHandler(nil, nil);
            }
        }) { (operation, error) in
            completionHandler(nil, error)
        }
        
    }
    
    func searchByName(_ name : String!, _ completionHandler: @escaping (_ contries: [[String : Any]]?, _ error: Error?) -> ()) {
        
        let escapedName = name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

        manager.get("\(baseURL)name/\(escapedName!)", parameters: nil, progress: { (progress) in
            
        }, success: { (operation, responseObject) in
            if let result = responseObject as? [[String : Any]] {
                completionHandler(result, nil)
            } else {
                completionHandler(nil, nil);
            }
        }) { (operation, error) in
            completionHandler(nil, error)
        }
        
    }
    
}
