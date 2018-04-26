//
//  DetailsViewController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 3/11/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

final class DetailViewController: UIViewController, CLLocationManagerDelegate {
    
    private let clManager = CLLocationManager()
    
    var marketDetails: Details?
    var marketID: MarketIdentifier?
    fileprivate var website: String?
    fileprivate var facebook: String?
    fileprivate var urlResponse: HTTPURLResponse?
    
    @IBOutlet weak private var farmersMarketImage: UIImageView!
    @IBOutlet weak private var addressLabel: PaddingLabel!
    @IBOutlet weak private var scheduleLabel: PaddingLabel!
    @IBOutlet weak private var productsTextView: UITextView!
    @IBOutlet weak private var titleOfFarmersMarketLabel: UILabel!
    @IBOutlet weak private var farmersMarketTitleLabel: UINavigationItem!
    @IBOutlet weak private var radishLinkButton: UIButton!
    @IBOutlet weak private var getDirectionsButton: UIButton!
    @IBOutlet weak private var contentView: UIView!
    fileprivate var goToWebsiteButton: UIButton! = {
        let button = UIButton()
        button.setTitle("Go to Website", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.1058823529, green: 0.1882352941, blue: 0.431372549, alpha: 1)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()
    
    // MARK: - View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMarketIDFromLocalFile(with: (marketID?.id)!)
        getHTTPStatusFromURL()
        radishLinkButton.isEnabled = false
        clManager.delegate = self
        setupGetDirectionsButtonAndFarmersMarketImage()
        updateViews()
        view.backgroundColor = .white
        UINavigationBar.appearance().backgroundColor = view.backgroundColor
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupWebsiteAndDirectionsButtons()
    }
    
    // Updates to the corresponding views
    private func updateViews() {
        
        // So this code wont be everywhere, i just decided to make it a custom property
        let formattedScheduleLabel = marketDetails?.schedule?
            .replacingOccurrences(of: ";<br> ", with: "")
            .replacingOccurrences(of: ";", with: ", ")
            .replacingOccurrences(of: "<br>", with: "")
        
        guard let newMarketName = marketID?.marketname else { return }
        let resultWithOutNumbers = newMarketName.index(newMarketName.startIndex, offsetBy: 4)
        let resultBackToString = newMarketName[resultWithOutNumbers...]
        let trimmedWhiteSpaceString = resultBackToString.trimmingCharacters(in: .whitespacesAndNewlines)
        titleOfFarmersMarketLabel.text = trimmedWhiteSpaceString
        let titleOfImage = UIImage(named: "TitleOfApp")
        let imageView = UIImageView(image: titleOfImage)
        farmersMarketTitleLabel.titleView = imageView
        addressLabel.text = marketDetails?.address
        scheduleLabel.text = formattedScheduleLabel
        
        // Makes sure if there is no info for the Schedule, it helps the person find a reason why
        scheduleLabel.text = formattedScheduleLabel?.replacingOccurrences(of: "    ", with: "If there is no information provided for the Schedule, please click on the radish so the Farmers Market can show more information")
        productsTextView.text = marketDetails?.products?.replacingOccurrences(of: "; ", with: "\n")
        
        // Logic to help if there is no text for the schedule and products then it will set a custom display
        if productsTextView.text == "" && (scheduleLabel.text?.contains("If"))! {
            radishLinkButton.isEnabled = true
            scheduleLabel.text = formattedScheduleLabel?
                .replacingOccurrences(of: "    ", with:  "If there is no information provided for the Schedule or Products, please click on the radish so the Farmers Market can show more information")
        // Checks to see if there is nothing in the schedule and there are products displayed
        } else if (scheduleLabel.text?.contains("If"))! && productsTextView.text.isEmpty == false {
            radishLinkButton.isEnabled = true
            productsTextView.text = marketDetails?.products?.replacingOccurrences(of: "; ", with: "\n")
            print(productsTextView.text)
        
        // checks to see if there is there is text in the schedle and not in the Products
        } else if scheduleLabel.text == formattedScheduleLabel && productsTextView.text == "" {
            radishLinkButton.isEnabled = true
            productsTextView.text = marketDetails?.products?
                .replacingOccurrences(of: "", with: "If there is no information provided please click on the radish so the Farmers Market can show more information")
        }
    }
    
    private func setupGetDirectionsButtonAndFarmersMarketImage() {
        getDirectionsButton.layer.cornerRadius = getDirectionsButton.frame.height/2
        getDirectionsButton.clipsToBounds = true
        getDirectionsButton.layer.borderWidth = 1
        
        farmersMarketImage.layer.cornerRadius = 12
        farmersMarketImage.clipsToBounds = true
    }
    
    // MARK: - Actions
    @IBAction private func radishLinkButtonTapped(_ sender: Any) {
        radishLinkButton.pulsate()
        let urlString = "http://www.usdalocalfooddirectories.com/farmersmarketdirectoryupdate/FM_Portal_Public.aspx"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
   
    @IBAction private func addressButtonTapped(_ sender: Any) {
        getDirectionsButton.pulsate()
        addressLabel.textColor = UIColor.black

        guard let marketResult = marketDetails?.googleLink.customNumberedString else { return }

        let newResult = marketResult.replacingOccurrences(of: "220-", with: " -")
        let indexStartOfText = newResult.index(newResult.startIndex, offsetBy: 2)
      
        let resultsWithoutleadingDots = newResult[indexStartOfText...]
        let indexEndOfText = resultsWithoutleadingDots.index(resultsWithoutleadingDots.endIndex, offsetBy: -6)
        let resultsWithoutTrailingNumbers = resultsWithoutleadingDots[..<indexEndOfText]

        let resultsArray = resultsWithoutTrailingNumbers.components(separatedBy: " ")
        guard let latitude = Double(resultsArray[0]) else { return }
        guard let longitude = Double(resultsArray[1]) else { return }

        let regionDistance: CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)

        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = marketDetails?.address
        mapItem.openInMaps(launchOptions: options)

    }
    
    // This transitions the view to go to the farmers market website
    @objc fileprivate func goToWebsiteButtonTapped(_ sender: UIButton) {
        let webString = website
        let facebookString = facebook
        if webString == "" {
            if let url = URL(string: facebookString!) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        } else {
            if let url = URL(string: webString!) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    // This makes sure the products is always at the top of the productsTextView
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        productsTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
}

extension DetailViewController {
    
    // This makes it go to whatever website corresponds with the farmers market id
    fileprivate func fetchMarketIDFromLocalFile(with id: String) {
        let path = Bundle.main.path(forResource: "websitesAndIDs", ofType: ".json")
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            let websiteAndIDs = try JSONDecoder().decode(MarketWebsiteDictionary.self, from: data)
            let results = websiteAndIDs.results
            
            for result in results {
                if "\(result.fmid)" == id {
                    if result.website == "" {
                        website = ""
                        if result.facebook == "" {
                            facebook = ""
                        } else {
                            facebook = result.facebook
                        }
                    } else {
                        website = result.website
                    }
                }
            }
        } catch {
            NSLog("Error with parsing JSON from local file \(error.localizedDescription, #function)")
        }
    }
}

extension DetailViewController {

    // Fetches the HTTPResponse from the URL
    fileprivate func getHTTPStatusFromURL() {
        let webString = website
        if webString == "" {
            return
        }
        let url = URL(string: webString!)
        DispatchQueue.main.async { [weak self] in
            let dataTask = URLSession.shared.dataTask(with: url!) { (_, response, error) in
                if error != nil {
                    NSLog("error with URLSession \(String(describing: error?.localizedDescription))")
                }
                if let httpResponse = response as? HTTPURLResponse {
                    self?.urlResponse = httpResponse
                }
            }
            dataTask.resume()
        }
    }
}

extension DetailViewController {

    // checks to see if the HTTP Status is okay and if not it returns out of the function
    fileprivate func setupWebsiteAndDirectionsButtons() {
        let statusCode = urlResponse?.statusCode
        if statusCode == 404 || statusCode == 401 || statusCode == 403 || statusCode == 405 || (website == "" && facebook == "") {
            return
        } else {
            view.addSubview(goToWebsiteButton)
            goToWebsiteButton.translatesAutoresizingMaskIntoConstraints = false
            goToWebsiteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 21).isActive = true
            goToWebsiteButton.topAnchor.constraint(equalTo: productsTextView.bottomAnchor, constant: 21).isActive = true
            goToWebsiteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            goToWebsiteButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
            goToWebsiteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIScreen.main.bounds.width/2 - 8).isActive = true
            view.addSubview(getDirectionsButton)
            getDirectionsButton.translatesAutoresizingMaskIntoConstraints = false
            getDirectionsButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 21).isActive = true
            getDirectionsButton.topAnchor.constraint(equalTo: productsTextView.bottomAnchor, constant: 21).isActive = true
            getDirectionsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIScreen.main.bounds.width/2 + 8).isActive = true
        }
        // Sets up the Website function
        goToWebsiteButton.addTarget(self, action: #selector(goToWebsiteButtonTapped), for: .touchUpInside)
    }
}












