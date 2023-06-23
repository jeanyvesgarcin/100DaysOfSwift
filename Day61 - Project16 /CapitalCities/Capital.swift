//
//  Capital.swift
//  Day61 - Project16
//
//  Created by Jean-Yves Garcin on 22/06/2023.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var wikiUrl: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, wikiUrl: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.wikiUrl = wikiUrl
    }
}
