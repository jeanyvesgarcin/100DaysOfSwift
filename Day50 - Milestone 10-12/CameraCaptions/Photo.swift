//
//  Photo.swift
///  Day50 - Milestone 10-12
//
//  Created by Jean-Yves Garcin on 18/06/2023.
//

import UIKit

class Photo: NSObject, Codable {
    var imageFileName: String
    var caption: String
    
    init(imageFileName: String, caption: String) {
        self.imageFileName = imageFileName
        self.caption = caption
    }
}
