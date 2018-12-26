//
//  ResourcesManager.swift
//  Atlas
//
//  Created by Pavel Belevtsev on 12/26/18.
//  Copyright © 2018 Pavel Belevtsev. All rights reserved.
//

import UIKit

class ResourcesManager: NSObject {

    static let shared = ResourcesManager()
    
    var flagsData = [[String : String]]()
    var regions = [[String : Any]]()
    
    override init() {
        super.init()
        
        loadData()
    }
    
    func loadData() {
        
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [[String : String]] {
                    flagsData = jsonResult
                }
            } catch {
                
            }
        }
        
        if let path = Bundle.main.path(forResource: "regions", ofType: "plist") {
            regions = NSArray(contentsOfFile: path) as! [[String : Any]]
        }
        
    }
    
}
