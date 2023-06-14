//
//  Person.swift
//  Day42-43 - Project10
//
//  Created by Jean-Yves Garcin on 14/06/2023.
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
