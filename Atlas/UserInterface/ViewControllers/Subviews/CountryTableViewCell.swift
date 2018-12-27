//
//  CountryTableViewCell.swift
//  Atlas
//
//  Created by Pavel Belevtsev on 12/27/18.
//  Copyright © 2018 Pavel Belevtsev. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet weak var labelFlag: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelNativeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.prepareForReuse()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.labelFlag.text = ""
        self.labelName.text = ""
        self.labelNativeName.text = ""
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateForCountry(_ country : [String : Any]!) {
        self.updateForCountry(country, true)
    }
    
    func updateForCountry(_ country : [String : Any]!, _ withNativeName : Bool) {
        if let code = country["alpha2Code"] as? String {
            labelFlag.text = ResourcesManager.shared.flagByCode(code)
        }
        if let name = country["name"] as? String {
            labelName.text = name
        }
        if (withNativeName) {
            if let nativeName = country["nativeName"] as? String {
                labelNativeName.text = nativeName
            }
        }
    }
    
}
