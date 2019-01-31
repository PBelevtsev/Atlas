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
        
        prepareForReuse()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        labelFlag.text = ""
        labelName.text = ""
        labelNativeName.text = ""
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateForCountry(_ country : Country!) {
        updateForCountry(country, true)
    }
    
    func updateForCountry(_ country : Country!, _ withNativeName : Bool) {
        labelFlag.text = ResourcesManager.shared.flagByCode(country.alpha2)
        labelName.text = country.name
        if (withNativeName) {
            labelNativeName.text = country.nativeName
        }
    }
    
}
