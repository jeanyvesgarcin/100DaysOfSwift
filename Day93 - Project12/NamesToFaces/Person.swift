//
//  Person.swift
//  Day93 - Project12
//
//  Created by Jean-Yves Garcin on 28/06/2023.
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
