//
//  AccountMainViewController.swift
//  All In One
//
//  Created by Barış Arslan on 12.09.2023.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import CoreLocation

class AccountMainViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    
    let user = Auth.auth().currentUser
    let locationManager = CLLocationManager()
    
    var weatherManager = WeatherManager()
    
    
//    @objc func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            let latitude = location.coordinate.latitude
//            let longitude = location.coordinate.longitude
//            // Koordinatları kullanmak için burada işlem yapabilirsiniz
//        }
//    }

//    @objc func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        // Hata durumunda burada işlem yapabilirsiniz
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        searchField.delegate = self
        weatherManager.delegate = self
  
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
//        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // Konum hassasiyetini ayarlayabilirsiniz
//        locationManager.requestWhenInUseAuthorization() // Kullanım sırasında konum izni isteği
//
//        locationManager.startUpdatingLocation()
   
    }

}

extension AccountMainViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitute: long)
            print("kontrol")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

extension AccountMainViewController: WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel) {
        DispatchQueue.main.async {
            self.tempLabel.text = weather.calculateTemp
            self.weatherImageView.image = UIImage(systemName: weather.conditionalName)
            self.cityLabel.text = weather.cityName
            self.descriptionLabel.text = weather.description
            
        }
    }
    func didFailWithError(error: Error) {
        print(error)
        print("error geliyor")
    }
}




extension AccountMainViewController: UITextFieldDelegate{
    
    @IBAction func textFieldPressed(_ sender: UIButton) {
        
        if searchField.text != ""{
            
            searchField.endEditing(true)
            
            
        }else{
            searchField.placeholder = "type something"
            
        }
        
        print(searchField.text!)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        printContent(textField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = textField.text{
            print(city)
            weatherManager.fetchWeather(cityName: city)
        }
        textField.text = ""
        
    }
    
}

