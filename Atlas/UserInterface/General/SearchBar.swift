//
//  SearchBar.swift
//  Atlas
//
//  Created by Pavel Belevtsev on 12/27/18.
//  Copyright © 2018 Pavel Belevtsev. All rights reserved.
//

import UIKit

public class SearchBar: UISearchBar, UISearchBarDelegate {
    
    /// Throttle engine
    private var throttler: Throttler? = nil
    
    /// Throttling interval
    public var throttlingInterval: Double? = 0 {
        didSet {
            guard let interval = throttlingInterval else {
                self.throttler = nil
                return
            }
            self.throttler = Throttler(seconds: interval)
        }
    }
    
    /// Event received when cancel is pressed
    public var onCancel: (() -> (Void))? = nil
    
    /// Event received when a change into the search box is occurred
    public var onSearch: ((String) -> (Void))? = nil
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
    }
    
    // Events for UISearchBarDelegate
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.onCancel?()
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //self.onSearch?(self.text ?? "")
        self.resignFirstResponder()
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let throttler = self.throttler else {
            self.onSearch?(searchText)
            return
        }
        throttler.throttle {
            DispatchQueue.main.async {
                self.onSearch?(self.text ?? "")
            }
        }
    }
    
    public func searchText() -> String! {
        return (self.text ?? "")
    }
    
}
