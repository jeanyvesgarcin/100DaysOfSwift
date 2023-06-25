//
//  Note.swift
//  Day74 - Milestone - Projects 19-20-21
//
//  Created by Jean-Yves Garcin on 25/06/2023.
//

import Foundation

class Note: Codable {
    var uuid: String?
    var content: String?
    var folderUuid: String?
    
    init(content: String, folderUuid: String) {
        self.content = content
        self.folderUuid = folderUuid
        self.uuid = UUID().uuidString
    }
}
