//
//  MapViewController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 3/11/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate , UISearchBarDelegate {
    
    lazy var mapView: MKMapView = {
        let mapview = MKMapView()
        mapview.delegate = self
        return mapview
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setMyHomeTownPosition()
        mapView.frame = self.view.frame
        view.addSubview(mapView)
    }
    
    @IBAction func searchBarButtonTapped(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        let searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.placeholder = "Enter your zip..."
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        dismiss(animated: true, completion: nil)
        DispatchQueue.main.async { [weak self] in
            if let searchTerm = searchBar.text {
                MarketController.shared.fetchFarmersMarketData(with: searchTerm) { (results, error) in
                    if let err = error { NSLog("error with fetching MarketData \(err.localizedDescription) \(#function)"); self?.noZipcodeFoundAlert(); return }
                    
                    guard let results = results else { return }
                    
                    for result in results.results! {
                        print(result.marketname)
                        guard let id = result.id else { return }
                        MarketController.shared.getStaticData(with: id, completion: { (details, error) in
                            if let err = error { NSLog("error with fetching Data \(err.localizedDescription) \(#function)"); self?.noZipcodeFoundAlert(); return }
                            guard let details = details, let marketDetails = details.marketdetails else { return }
                            
                            self?.changeAddressToCoordinates(details: marketDetails)
                        })
                    }
                    
                }
                
            }
        }
    }
   
    
    var location = CLLocation()
    
    func changeAddressToCoordinates(details: Details) {
        let geocoder = CLGeocoder()
        //DispatchQueue.main.async { [weak self] in
        //guard let marketName = marketID.marketname else { return }
        guard let address = details.Address else { return }
        let annotation = MarketAnnotation(marketDetails: details)
        geocoder.geocodeAddressString(address) {
            placemarks, error in
            let placemark = placemarks?.first
            guard let lat = placemark?.location?.coordinate.latitude else { return }
            guard let lon = placemark?.location?.coordinate.longitude else { return }
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            //annotation.title = marketName
            annotation.title = address
            let span = MKCoordinateSpanMake(1, 1)
            let region = MKCoordinateRegionMake(annotation.coordinate, span)
            self.mapView.setRegion(region, animated: true)
            self.mapView.addAnnotation(annotation)
        }
        //}
    }
    
    
    func setMyHomeTownPosition() {
        DispatchQueue.main.async { [weak self] in
            let visibleRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: 38.729613, longitude: -120.798601), 1000, 1000)
            self?.mapView.setRegion((self?.mapView.regionThatFits(visibleRegion))!, animated: true)
        }
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //2
        guard let annotation = annotation as? MarketAnnotation else {
            return nil
        }
        //3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        //4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            //5
            view = MKMarkerAnnotationView.init(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint.init(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure)
        }
        return view
    }
    var details: Details?
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            guard let annotation = view.annotation as? MarketAnnotation else { return }
            details = annotation.marketDetail
            performSegue(withIdentifier: "toDetailVC", sender: view)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDetailVC" )
        {
            if let destination = segue.destination as? DetailsViewController {
                destination.marketDetails = details
            }
        }
        
    }
    func noZipcodeFoundAlert() {
        let alert = UIAlertController(title: "No Results", message: "There has been an error with finding the Farmers Markets you are looking for, please try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

}









