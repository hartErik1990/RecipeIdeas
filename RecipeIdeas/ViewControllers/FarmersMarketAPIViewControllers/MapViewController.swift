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

final class MapViewController: UIViewController, MKMapViewDelegate , UISearchBarDelegate, CLLocationManagerDelegate {
    
    // MARK: - Properties
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet weak var getLocationButton: CustomButton!

    private weak var location = CLLocation()
    private weak var details: Details?
    private weak var marketID: MarketIdentifier?
    let clLocationManager = CLLocationManager()

    // MARK: - assigning Delegate and Authorization
    func locationManagerDelegateAndAuthorization() {
        clLocationManager.delegate = self
        clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        clLocationManager.requestWhenInUseAuthorization()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        setMyHomeTownPosition()
        locationManagerDelegateAndAuthorization()
        mapView.frame = self.view.frame
        view.addSubview(mapView)
        mapView.addSubview(getLocationButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
            self.mapView.addSubview(getLocationButton)
            self.getLocationButton.alpha = 1
            self.getLocationButton.isEnabled = true
            self.addPulseTo(center: getLocationButton.center, withRadius: 100, withColor: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1).cgColor)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(navigationController?.viewControllers.count)
        if navigationController?.viewControllers.count != 2 {
            self.view = nil
        } else {
            print("This is doing its job correctly")
        }
    }
    // MARK: - LocationManager Delegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let location = locations.first else { return }

        let span: MKCoordinateSpan = MKCoordinateSpanMake(2, 2)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
    @IBAction func getLocationButtonTapped(_ sender: Any) {
        
        guard let locationValue: CLLocationCoordinate2D = clLocationManager.location?.coordinate else { return }
        
        
        DispatchQueue.main.async { [weak self] in
        MarketController.shared.getLocation(With: locationValue.latitude, and: locationValue.longitude) { (results, error) in
                
                self?.getResultsAndErrorWithFetchCall(with: results, and: error)
            }
            self?.clLocationManager.startUpdatingLocation()
            self?.getLocationButton.alpha = 0
            self?.getLocationButton.isEnabled = false
            self?.mapView.showsUserLocation = true
        }
    }
    
    @IBAction func searchBarButtonTapped(_ sender: Any) {
        mapView.showsUserLocation = false 
        let searchController = UISearchController(searchResultsController: nil)
        let searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.placeholder = "Enter your zip..."
        mapView.removeAnnotations(mapView.annotations)
        present(searchController, animated: true, completion: nil)
        
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        dismiss(animated: true, completion: nil)
        if let searchTerm = searchBar.text {
            
            MarketController.shared.fetchFarmersMarketData(with: searchTerm) { (results, error) in
                self.getResultsAndErrorWithFetchCall(with: results, and: error)
            }
        }
    }

    // Loops through the results array and calls the function to
    private func getResultsAndErrorWithFetchCall(with results: FarmersMarketResults?, and error: Error?) {
        if let err = error { NSLog("error with fetching MarketData \(err.localizedDescription) \(#function)"); noZipcodeFoundAlert(); return }
        
        guard let results = results?.results else { return }
        
        for result in results {
            guard let id = result.id else { return }
            MarketController.shared.fetchIdFromFarmersMarketResults(with: id, completion: { (details, error) in
                DispatchQueue.main.async { [weak self] in
                    if let err = error { NSLog("error with fetching Data \(err.localizedDescription) \(#function)"); self?.noZipcodeFoundAlert(); return }
                    guard let details = details, let marketDetails = details.marketdetails else { return }
                    self?.changeAddressToCoordinates(details: marketDetails, marketID: result)
                }
            })
            
        }
    }
    
    
    // checks the address and adds the annotation to the map
    private func changeAddressToCoordinates(details: Details, marketID: MarketIdentifier) {
        
        let geocoder = CLGeocoder()
        
        let marketName = marketID.marketname
        guard let address = details.Address, let newMarketName = marketName else { return }
        let annotation = MarketAnnotation(marketDetails: details, marketID: marketID)
        geocoder.geocodeAddressString(address) {
            placemarks, error in
            let placemark = placemarks?.first
            guard let lat = placemark?.location?.coordinate.latitude else { return }
            guard let lon = placemark?.location?.coordinate.longitude else { return }
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            print(address)
            let span = MKCoordinateSpanMake( 1, 1)
            let region = MKCoordinateRegionMake(annotation.coordinate, span)
            self.mapView.setRegion(region, animated: true)
        }
        let resultWithOutNumbers = newMarketName.index(newMarketName.startIndex, offsetBy: 4)
        let resultBackToString = newMarketName[resultWithOutNumbers...]
        annotation.title = resultBackToString.components(separatedBy: "")[0]
        mapView.addAnnotation(annotation)
        
    }
    
    //sets the onboard location to my hometown
    private func setMyHomeTownPosition() {
        DispatchQueue.main.async { [weak self] in
            let visibleRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: 38.729613, longitude: -120.798601), 1000, 1000)
            self?.mapView.setRegion((self?.mapView.regionThatFits(visibleRegion))!, animated: true)
        }
        
    }
    
    // calls the custom annotation and gives the annotation a detail disclosure
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? MarketAnnotation else {
            return nil
        }

        let identifier = "marker"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
            //view.glyphTintColor = UIColor.clear
            view.glyphImage = UIImage(named: "house")
            view.markerTintColor = UIColor(red: 78.0/255.0, green: 114.0/255.0, blue: 72.0/255.0, alpha: 1.0)

        } else {
            view = MKMarkerAnnotationView.init(annotation: annotation, reuseIdentifier: identifier)
            view.glyphImage = UIImage(named: "house")
            view.markerTintColor = UIColor(red: 78.0/255.0, green: 114.0/255.0, blue: 72.0/255.0, alpha: 1.0)
            view.canShowCallout = true
            view.calloutOffset = CGPoint.init(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure)
        }
        return view

    }
    
    // MARK: - Segue to the DetailViewController
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            guard let annotation = view.annotation as? MarketAnnotation else { return }
            details = annotation.marketDetail
            marketID = annotation.marketID
            performSegue(withIdentifier: "toDetailVC", sender: view)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDetailVC" )
        {
            if let destination = segue.destination as? DetailViewController {
                destination.marketDetails = details
                destination.marketID = marketID
            }
        }
        
    }
    
    // MARK: - Alert for no zipcode
    private func noZipcodeFoundAlert() {
        let alert = UIAlertController(title: "No Results", message: "There has been an error with finding the Farmers Markets you are looking for, please try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Pulsating function
    func addPulseTo(center: CGPoint, withRadius radius: CGFloat, withColor: CGColor) {
        
            let pulse = PulseAnimation(numberOfPulses: 5, radius: radius, position: center)
            pulse.animationDuration = 1.5
            pulse.backgroundColor = withColor
            self.view.layer.insertSublayer(pulse, below: self.view.layer)
    }

}








