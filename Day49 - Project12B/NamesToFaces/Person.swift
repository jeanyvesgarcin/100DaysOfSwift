//
//  Person.swift
//  Day49 - Project12B
//
//  Created by Jean-Yves Garcin on 18/06/2023.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
