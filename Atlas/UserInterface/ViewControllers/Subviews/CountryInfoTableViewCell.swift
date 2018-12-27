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
        
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.labelFlag.text = ""
        self.labelCurrency.text = " "
        self.labelLanguage.text = " "
        self.labelBoardsWith.text = ""
        self.mapView.removeAnnotations(self.mapView.annotations)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateForCountry(_ country : [String : Any]!, _ countries : [[String : Any]]?) {
        
        print("\(country!)")
        if let code = country["alpha2Code"] as? String {
            labelFlag.text = ResourcesManager.shared.flagByCode(code)
        }
        if let currencies = self.namesFromArray(country, "currencies") {
            self.labelCurrency.text = currencies.joined(separator: ", ")
        }
        if let languages = self.namesFromArray(country, "languages") {
            self.labelLanguage.text = languages.joined(separator: ", ")
        }
        if let latlng = country["latlng"] as? [Double] {
            if latlng.count == 2 {
                let center = CLLocationCoordinate2D(latitude: latlng[0], longitude: latlng[1])
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0))
                self.mapView.setRegion(region, animated: false)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = center
                self.mapView.addAnnotation(annotation)
            }
        }
        if countries != nil {
            self.labelBoardsWith.text = "Boards with:"
        }
    }
    
    func namesFromArray(_ country : [String : Any]!, _ field : String!) -> [String]? {
        if let array = country[field] as? [[String : String]] {
            var names = [String]()
            for item in array {
                if let name = item["name"] {
                    names.append(name)
                }
            }
            if names.count > 0 {
                return names
            }
        }
        
        return nil
    }
}
