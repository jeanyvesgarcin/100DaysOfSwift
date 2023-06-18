//
//  DetailViewController.swift
//  Day50 - Milestone 10-12
//
//  Created by Jean-Yves Garcin on 18/06/2023.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var caption: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = caption
        
        navigationItem.largeTitleDisplayMode = .never

        if let imageToLoad = selectedImage {
            let path = getDocumentsDirectory().appendingPathComponent(imageToLoad)
            imageView.image = UIImage(contentsOfFile: path.path)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
