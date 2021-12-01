//
//  WeatherViewController.swift
//  Covid-19_Questionnaire
//
//  Created by Miguel Barajas on 11/26/21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var grassValueLabel: UILabel!
    @IBOutlet weak var treeValueLabel: UILabel!
    @IBOutlet weak var weedValueLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var spinnerView: UIView!
    
    var weatherManager = WeatherManager()
    var pollenManager = PollenManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        stopLoadingContent()
        locationManager.requestWhenInUseAuthorization() // request permission to get user location
        
        if CLLocationManager.locationServicesEnabled() {
            if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
                locationManager.requestLocation() // gets user location one single time
                startLoadingContent()
                weatherManager.delegate = self
                pollenManager.delegate = self
                searchTextField.delegate = self
            }
        }
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        startLoadingContent()
    }
    
    /// Displays an activity indicator to let the user know content is being loaded
    func startLoadingContent() {
        spinner.startAnimating()
        spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        spinner.hidesWhenStopped = false
        spinnerView.isHidden = false
    }
    
    /// removes the activity indicator from the screen
    func stopLoadingContent() {
        spinner.stopAnimating()
        spinner.hidesWhenStopped = true
        spinnerView.isHidden = true
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
            pollenManager.fetchPollen(cityName: city)
        }
        
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - PollenManagerDelegate

extension WeatherViewController: PollenManagerDelegate {
    func didUpdatePollen(_ pollenManager: PollenManager, pollen: PollenModel) {
        DispatchQueue.main.async {
            self.grassValueLabel.text = pollen.grass
            self.treeValueLabel.text = pollen.tree
            self.weedValueLabel.text = pollen.weed
        }
    }
    
    func pollenDidFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            locationManager.stopUpdatingLocation()
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
            pollenManager.fetchPollen(latitude: lat, longitude: lon)
            stopLoadingContent()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
