//
//  ViewController.swift
//  Day61 - Project16
//
//  Created by Jean-Yves Garcin on 22/06/2023.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Capital Cities"
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics", wikiUrl: "https://en.wikipedia.org/wiki/London")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago", wikiUrl: "https://en.wikipedia.org/wiki/oslo")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light", wikiUrl: "https://en.wikipedia.org/wiki/Paris")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.", wikiUrl: "https://en.wikipedia.org/wiki/Rome")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.", wikiUrl: "https://en.wikipedia.org/wiki/Washington,_D.C.")
        let perpignan = Capital(title: "Perpignan", coordinate: CLLocationCoordinate2D(latitude: 42.698601, longitude: 2.895600), info: "Salvador Dali's Center of the World", wikiUrl: "https://en.wikipedia.org/wiki/Perpignan")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington, perpignan])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeMapStyle))
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.pinTintColor = .cyan
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        mapView.deselectAnnotation(view.annotation, animated: true)

        if let vc = storyboard?.instantiateViewController(withIdentifier: "sb_DetailViewController") as? DetailViewController {
            vc.capital = capital
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func changeMapStyle() {
        let ac = UIAlertController(title: "Map Style", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: { (action) in
            self.mapView.mapType = .hybrid
        }))
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: { (action) in
            self.mapView.mapType = .satellite
        }))
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: { (action) in
            self.mapView.mapType = .standard
        }))
        present(ac, animated: true)
    }
}

