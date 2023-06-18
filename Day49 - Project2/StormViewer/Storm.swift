//
//  Storm.swift
//  Day49 - Project2
//
//  Created by Jean-Yves Garcin on 18/06/2023.
//

import UIKit

class Storm: NSObject, Codable {
    var pictureName: String
    var viewCount: Int
    
    init(pictureName: String, viewCount: Int) {
        self.pictureName = pictureName
        self.viewCount = viewCount
    }
}
