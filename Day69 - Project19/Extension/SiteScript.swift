//
//  SiteScript.swift
//  Extension
//  Day69 - Project19
//
//  Created by Jean-Yves Garcin on 24/06/2023.
//

import Foundation

struct SiteScript: Codable {
    var scriptName: String?
    var urlPageTitle: String?
    var url: URL?
    var script: String?
    var uuid: String?
    
    mutating func assign(scriptName: String, url: URL, script: String, urlPageTitle: String) {
        self.scriptName = scriptName
        self.url = url
        self.script = script
        self.urlPageTitle = urlPageTitle
        self.uuid = UUID().uuidString
    }
    
    init(urlPageTitle: String, url: String) {
        self.scriptName = ""
        self.url = URL(string: url)
        self.script = ""
        
        self.urlPageTitle = urlPageTitle
        self.uuid = UUID().uuidString
    }
}
