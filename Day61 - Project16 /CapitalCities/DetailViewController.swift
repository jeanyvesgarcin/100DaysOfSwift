//
//  DetailViewController.swift
//  Day61 - Project16
//
//  Created by Jean-Yves Garcin on 22/06/2023.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    @IBOutlet var webView: WKWebView!
    
    var capital: Capital!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        
        title = capital.title
        
        if let url = URL(string: capital.wikiUrl) {
            webView.load(URLRequest(url: url))
        }
    }
}
