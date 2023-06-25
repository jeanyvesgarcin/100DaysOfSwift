//
//  Folder.swift
//  Day74 - Milestone - Projects 19-20-21
//
//  Created by Jean-Yves Garcin on 25/06/2023.
//

import Foundation

class Folder: Codable {
    var uuid: String?
    var name: String?
    
    init(name: String) {
        self.name = name
        self.uuid = UUID().uuidString
    }
}
