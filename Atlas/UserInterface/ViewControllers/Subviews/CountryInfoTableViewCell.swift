//
//  CountryInfoTableViewCell.swift
//  Atlas
//
//  Created by Pavel Belevtsev on 12/27/18.
//  Copyright © 2018 Pavel Belevtsev. All rights reserved.
//

import UIKit
import MapKit

class CountryInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var labelFlag: UILabel!
    @IBOutlet weak var labelCurrency: UILabel!
    @IBOutlet weak var labelLanguage: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var labelBoardsWith: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        labelFlag.text = ""
        labelCurrency.text = " "
        labelLanguage.text = " "
        labelBoardsWith.text = ""
        mapView.removeAnnotations(mapView.annotations)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateForCountry(_ country : Country!, _ countries : [Country]?) {
        
        labelFlag.text = ResourcesManager.shared.flagByCode(country.alpha2)
        
        labelCurrency.text = namesFromArray(country.currencies)
        labelLanguage.text = namesFromArray(country.languages)
        
        if country.latlng.count == 2 {
            let center = CLLocationCoordinate2D(latitude: country.latlng[0], longitude: country.latlng[1])
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0))
            mapView.setRegion(region, animated: false)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            mapView.addAnnotation(annotation)
        }
        if countries != nil {
            labelBoardsWith.text = "Boards with:"
        }
    }
    
    func namesFromArray(_ array : [[String : String]]!) -> String? {
        var names = [String]()
        for item in array {
            if let name = item["name"] {
                names.append(name)
            }
        }
        if names.count > 0 {
            return names.joined(separator: ", ")
        } else {
            return nil
        }
    }
}
