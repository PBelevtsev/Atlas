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
        manager.responseSerializer = AFHTTPResponseSerializer();
    }
    
    func parsingCountries(_ responseObject : Any?, _ completionHandler: @escaping (_ contries: [Country]?, _ error: Error?) -> ()) {
        
        if let data = responseObject as? Data {
            do {
                let decoder = JSONDecoder()
                let countries = try decoder.decode([Country].self, from:data)
                completionHandler(countries, nil);
            } catch let parsingError {
                completionHandler(nil, parsingError);
            }
        } else {
            completionHandler(nil, nil)
        }
    }
    
    func makeCountriesRequest(_ urlString : String, _ completionHandler: @escaping (_ contries: [Country]?, _ error: Error?) -> ()) {

        manager.get(urlString, parameters: nil, progress: { (progress) in
            
        }, success: { (operation, responseObject) in
            self.parsingCountries(responseObject, completionHandler)
        }) { (operation, error) in
            completionHandler(nil, error)
        }
    }
    
    func searchByRegion(_ type : String!, _ region : String!, _ completionHandler: @escaping (_ contries: [Country]?, _ error: Error?) -> ()) {
        
        makeCountriesRequest("\(baseURL)\(type!)/\(region!)", completionHandler)
        
    }
    
    func searchByName(_ name : String!, _ completionHandler: @escaping (_ contries: [Country]?, _ error: Error?) -> ()) {
        
        let escapedName = name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        makeCountriesRequest("\(baseURL)name/\(escapedName!)", completionHandler)
        
    }
    
    func searchByCodes(_ codes : [String]!, _ completionHandler: @escaping (_ contries: [Country]?, _ error: Error?) -> ()) {
        
        makeCountriesRequest("\(baseURL)alpha?codes=\(codes.joined(separator: ";"))", completionHandler)
        
    }
    
}
