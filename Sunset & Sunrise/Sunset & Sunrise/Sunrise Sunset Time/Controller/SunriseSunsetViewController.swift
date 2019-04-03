//
//  ViewController.swift
//  Sunset & Sunrise
//
//  Created by Святослав Катола on 3/25/19.
//  Copyright © 2019 mezzoSoprano. All rights reserved.
//

import GooglePlaces
import CoreLocation

class SunriseSunsetViewController: UIViewController {
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var dayLengthLabel: UILabel!
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    @IBOutlet weak var twilightBeginTimeLabel: UILabel!
    @IBOutlet weak var twilightEndTimeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var selectedDate: Date?
    var selectedLocation: CLLocationCoordinate2D?
    
    lazy var locationManager = CLLocationManager()
    lazy var sunsetManager = APISunriseSunsetManager(sessionConfiguration: URLSessionConfiguration.default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //default date - current
        self.selectedDate = datePicker.date
        
        //accessing user location
        self.setupLocationManager()
        self.locationManager.requestLocation()
    }
    
    fileprivate func updateLabelsWith(_ receivedInfo: SunriseSunset) {
        if let location = self.selectedLocation {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude), completionHandler: { (placemarks, error) -> Void in
                if let place = placemarks?[0] {
                    let place = Place(name: place.name, timeZone: place.timeZone)
                    let sunriseSunsetViewModel = SunriseSunsetViewModel(info: receivedInfo.info, place: place)
                    
                    self.dayLengthLabel.text = sunriseSunsetViewModel.dayLength
                    self.sunriseTimeLabel.text = sunriseSunsetViewModel.sunriseLocalTime
                    self.sunsetTimeLabel.text = sunriseSunsetViewModel.sunsetLocalTime
                    self.twilightEndTimeLabel.text = sunriseSunsetViewModel.twilightEndLocalTime
                    self.twilightBeginTimeLabel.text = sunriseSunsetViewModel.twilightBeginLocalTime
                    self.locationNameLabel.text = sunriseSunsetViewModel.locationName
                    
                } else {
                    if let gError = error {
                        self.createAlert(title: "CLGeocoder trouble", message: gError.localizedDescription)
                    }
                }
            })
        }
    }
    
    fileprivate func fetchInfo() {
        if let location = selectedLocation, let date = self.selectedDate {
            self.sunsetManager.fetchWithDate(coordinates: Coordinates(latitude: location.latitude, longitute: location.longitude), date: date) { (result) in
                
                switch result {
                    
                case .Success(let receivedInfo):
                    self.updateLabelsWith(receivedInfo)
                    
                case .Failure(let error as NSError):
                    self.createAlert(title: "Unable to get data", message: error.localizedDescription)
                    print(error)
                    
                default: break
                }
            }
        } else {
            //accessing user location
            self.checkLocationAuthorization()
        }
    }
    
    @IBAction func dateDidChange(_ sender: UIDatePicker) {
        self.selectedDate = sender.date
    }
    
    //presenting autocomplete controller
    @IBAction func searchTapped(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        self.fetchInfo()
    }
}

extension SunriseSunsetViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        
        self.selectedLocation = place.coordinate
        self.fetchInfo()
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension SunriseSunsetViewController : CLLocationManagerDelegate {
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            break
            
        case .denied:
            self.createAlert(title: "Couldn't get your location", message: "You denied the use of location services for this app or location services are currently disabled in Settings.")
            break
            
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            
        case .restricted:
            self.createAlert(title: "Couldn't get your location", message: "This app is not authorized to use location services possibly due to active restrictions such as parental control.")
            break
            
        case .authorizedAlways:
            break
        }
    }
    
    func setupLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.selectedLocation = locationManager.location?.coordinate
        self.fetchInfo()
    }
}


