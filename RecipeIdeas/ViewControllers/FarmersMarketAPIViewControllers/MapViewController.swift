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

final class MapViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    
    // MARK: - Properties
    @IBOutlet fileprivate weak var mapView: MKMapView!
    fileprivate var searchBarTextField: UISearchBar!
    fileprivate var location = CLLocation()
    fileprivate var details: Details?
    fileprivate var marketID: MarketIdentifier?
    fileprivate let clLocationManager = CLLocationManager()
    fileprivate let customImageView = UIImage(named: "AnnotationFarmet")
    var marketResultsArray = [MarketIdentifier?]()
    var detailsArray = [Details]()
    
    fileprivate var searchButton: UIButton! = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = #colorLiteral(red: 0.01776420884, green: 0.1898277998, blue: 0.2863296866, alpha: 1)
        button.isHidden = true
        return button
    }()
    func setupSearchButton() {
        mapView.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        let safeView = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            searchButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            searchButton.widthAnchor.constraint(equalToConstant: 80),
            searchButton.bottomAnchor.constraint(equalTo: safeView.bottomAnchor, constant: -10)
            ])
    }
    
    // MARK: - set up searchBar constraints
    private func setupkeyboard() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.inputAccessoryView = keyboardToolbar
        searchBar.keyboardType = .decimalPad
        searchBar.placeholder = "Enter your zip..."
        searchBar.showsBookmarkButton = true
        searchBar.setImage(#imageLiteral(resourceName: "Final"), for: .bookmark, state: .normal)
        searchBar.setPositionAdjustment(UIOffset(horizontal: -2, vertical: 0), for: .bookmark)
        searchBarTextField = searchBar
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    private func setupSearchBarConstraints() {
        mapView.addSubview(searchBarTextField)
        searchBarTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBarTextField.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 20),
            searchBarTextField.widthAnchor.constraint(equalTo: mapView.widthAnchor),
            searchBarTextField.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            searchBarTextField.heightAnchor.constraint(equalToConstant: 60),
            ])
    }
    
    // MARK: - set up keyboard with search and cancel
    fileprivate var keyboardToolbar: UIToolbar = {
        var toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Search", style: .done, target: self, action:  #selector(doneButtonTapped))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = UIColor.red
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        
        return toolbar
    }()
    
    @objc fileprivate func doneButtonTapped() {
        searchBarSearchButtonClicked(searchBarTextField)
        searchBarTextField.text = ""
        searchBarTextField.resignFirstResponder()
        self.dismiss(animated: true)
    }
    
    @objc fileprivate func cancelButtonTapped() {
        searchBarTextField.resignFirstResponder()
        searchBarTextField.text = ""
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchButton()
        setMyHomeTownPosition()
        locationManagerDelegateAndAuthorization()
        mapView.frame = self.view.frame
        view.addSubview(mapView)
        mapView.delegate = self
        setupkeyboard()
        setupSearchBarConstraints()
        searchBarTextField.backgroundImage = UIImage()
    }
    
    // Clears the naviagation bar so only the search bar shows
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // Checks to see if there are two viewControllers in the view hierarchy and if not it sets it to nil
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if navigationController?.viewControllers.count != 2 {
            self.view = nil
        } else {
            print("This is doing its job correctly")
        }
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    // Click on the Bookmark Button to get the persons location
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        marketResultsArray = []
        searchButton.isHidden = false
        mapView.removeAnnotations(mapView.annotations)
        searchBar.resignFirstResponder()
        guard let locationValue: CLLocationCoordinate2D = clLocationManager.location?.coordinate else { return }
        print(locationValue)
        DispatchQueue.main.async { [weak self] in
            MarketController.shared.getLocation(from: locationValue.latitude, and: locationValue.longitude) { (results, error) in
                
                self?.getResultsAndErrorWithFetchCall(with: results, and: error)
            }
            self?.clLocationManager.startUpdatingLocation()
            self?.mapView.showsUserLocation = true
        }
    }
    
    // searchs for Farmers markets through the Zipcode
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        marketResultsArray = []
        searchButton.isHidden = false
        mapView.removeAnnotations(mapView.annotations)
        clLocationManager.delegate = nil
        mapView.showsUserLocation = false
        guard let searchBar = searchBarTextField else { return }
        searchBar.inputAccessoryView = keyboardToolbar
        searchBar.keyboardType = .numberPad
        searchBar.delegate = self
        searchBar.placeholder = "Enter your zip..."
        dismiss(animated: true, completion: nil)
        if let searchTerm = searchBar.text {
            
            MarketController.shared.fetchFarmersMarketData(with: searchTerm) { (results, error) in
                self.getResultsAndErrorWithFetchCall(with: results, and: error)
            }
        }
    }
    
    
    // Loops through the results array and calls the function to
    private func getResultsAndErrorWithFetchCall(with results: FarmersMarketResults?, and error: Error?) {
        if let err = error { NSLog(err.localizedDescription, #function); noZipcodeFoundAlert(); return }
        
        guard let marketResults = results?.results else { return }
        for result in marketResults {
            self.marketResultsArray.append(result)
            guard let id = result.id else { return }
            MarketController.shared.fetchIdFromFarmersMarketResults(with: id, completion: { (details, error) in
                DispatchQueue.main.async { [weak self] in
                    if let err = error { NSLog(err.localizedDescription, #function); self?.noZipcodeFoundAlert(); return }
                    guard let details = details, let marketDetails = details.marketdetails else { return }
                    
                    self?.detailsArray.append(marketDetails)
                    self?.changeAddressToCoordinates(details: marketDetails, marketID: result)
                    guard let annotations = self?.mapView.annotations else { return }
                    self?.mapView.showAnnotations(annotations, animated: true)
                }
            })
        }
    }
    
    // checks the address and adds the annotation to the map
    private func changeAddressToCoordinates(details: Details, marketID: MarketIdentifier) {
        
        guard let marketName = marketID.marketname, let products = details.Products else { return }
        let annotation = MarketAnnotation(marketDetails: details, marketID: marketID)
        
        guard let marketResult = details.GoogleLink?.replacingOccurrences( of:"[^0.0-9, -]", with: "", options: .regularExpression) else { return }
        let newResult = marketResult.replacingOccurrences(of: "220-", with: " -")
        let indexStartOfText = newResult.index(newResult.startIndex, offsetBy: 2)
        
        let substring1 = newResult[indexStartOfText...]
        let indexEndOfText = substring1.index(substring1.endIndex, offsetBy: -6)
        let substring2 = substring1[..<indexEndOfText]
        
        let stringedArray = substring2.components(separatedBy: " ")
        guard let latitude = Double(stringedArray[0]) else { return }
        guard let longitude = Double(stringedArray[1]) else { return }
        
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        
        let resultWithOutNumbers = marketName.index(marketName.startIndex, offsetBy: 4)
        let resultBackToString = marketName[resultWithOutNumbers...]
        annotation.title = resultBackToString.components(separatedBy: "")[0]
        annotation.coordinate = coordinates
        
        mapView.addAnnotation(annotation)
        
    }
    
    //sets the onboard location to my hometown
    private func setMyHomeTownPosition() {
        DispatchQueue.main.async { [weak self] in
            let visibleRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: 38.729613, longitude: -120.798601), 100000, 100000)
            self?.mapView.setRegion((self?.mapView.regionThatFits(visibleRegion))!, animated: true)
        }
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
    @objc func searchButtonTapped(_ sender: UIButton) {
        //print(products)
        //print(resultsArray)
        mapView.removeAnnotations(mapView.annotations)
        let alert = UIAlertController(title: "Search for Produce", message: "Search for local produce in your area", preferredStyle: .alert)
        
        var produceTextField = UITextField()
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter here..."
            produceTextField = textField
        }
        
        let addAction = UIAlertAction(title: "Search", style: .default) { (action) in
            for result in self.marketResultsArray {
                guard let marketID = result?.id else { return }
                MarketController.shared.fetchIdFromFarmersMarketResults(with: marketID, completion: { (details, error) in
                    DispatchQueue.main.async { [weak self] in
                        if let err = error { NSLog(err.localizedDescription, #function); self?.noZipcodeFoundAlert(); return }
                        guard let details = details, let marketDetails = details.marketdetails else { return }
                        
                        let modifiedProductsArray = marketDetails.Products?.replacingOccurrences(of: ";", with: "").lowercased()
                            .replacingOccurrences(of: ",", with: "")
                        guard let productsArray = modifiedProductsArray?.components(separatedBy: " ") else { return }
                        print(productsArray)
                        
                        //                    var searchTerm: String? = Nuts
                        //                    searchTerm?.replacingOccurrences(of: ";", with: "")
                        guard let text = produceTextField.text?.lowercased(), !text.isEmpty else { return }
                        
                        let strippedText = text.stripped
                        
                        let textArray = strippedText.components(separatedBy: " ")
                        print(textArray)
                        for singleText in textArray {
                            if productsArray.contains(singleText) {
                                self?.changeAddressToCoordinates(details: marketDetails, marketID: result!)
                                guard let annotations = self?.mapView.annotations else { return }
                                self?.mapView.showAnnotations(annotations, animated: true)
                            }
                        }
                    }
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        searchButton.isHidden = true
        present(alert, animated: true, completion: nil)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    // MARK: - assigning Delegate and Authorization
    fileprivate func locationManagerDelegateAndAuthorization() {
        clLocationManager.delegate = self
        clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        clLocationManager.requestWhenInUseAuthorization()
    }
    
}

extension MapViewController {
    
    // MARK: - MapView Delegate
    
    // calls the custom annotation and gives the annotation a detail disclosure
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? MarketAnnotation else {
            return nil
        }
        
        let identifier = "marker"
        
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if view == nil {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view?.canShowCallout = true
            view?.image = customImageView
            view?.calloutOffset = CGPoint.init(x: -5, y: 5)
            view?.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure)
            
        } else {
            view?.annotation = annotation
        }
        
        return view
    }
    
    // MARK: - Custom Animation for the pindrop of the annotation
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
        var observiedView = -1
        for view in views {
            observiedView += 1
            if view.annotation is MKUserLocation {
                continue
            }
            guard let annotationView = view.annotation?.coordinate else { return }
            let point: MKMapPoint = MKMapPointForCoordinate(annotationView)
            if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
                continue
            }
            
            let endFrame: CGRect = view.frame
            
            view.frame = CGRect(origin: CGPoint(x: view.frame.origin.x,  y :view.frame.origin.y - self.view.frame.size.height), size: CGSize(width: view.frame.size.width, height: view.frame.size.height))
            
            let delay = 0.03 * Double(observiedView)
            UIView.animate(withDuration: 0.5, delay: delay, options: .curveEaseIn, animations:{() in
                view.frame = endFrame
                //annotation Drop
            }, completion:{(Bool) in
                UIView.animate(withDuration: 0.05, delay: 0.0, options: .curveEaseInOut, animations:{() in
                    view.transform = CGAffineTransform(scaleX: 1.0, y: 0.6)
                    //annotation Squash
                }, completion: {(Bool) in
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations:{() in
                        view.transform = .identity
                    }, completion: nil)
                })
            })
        }
    }
}

extension String {
    
    var stripped: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ")
        return self.filter {okayChars.contains($0) }
    }
}






