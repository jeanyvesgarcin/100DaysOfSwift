//
//  Person.swift
//  Day44 - Project10
//
//  Created by Jean-Yves Garcin on 16/06/2023.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
