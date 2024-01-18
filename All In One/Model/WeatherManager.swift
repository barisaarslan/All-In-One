//
//  WeatherManager.swift
//  All In One
//
//  Created by Barış Arslan on 13.09.2023.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    
    var delegate: WeatherManagerDelegate?
    
    let weatherUrl =  "buraya aşağıdaki alan adlarına özel kendi api keyinizi koymalısınız."
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(with: urlString)
        
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees){
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString)
    }
    
    
    
    
    
    func performRequest(with urlString: String){
        
        if let url = URL(string: urlString){
            //create a URL
            
            let session = URLSession(configuration: .default)
            //create a url session
            
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                    print(error!)
                    return
                }
                if let safeData = data{
                    if let weather = parseJSON(safeData){
                        delegate?.didUpdateWeather(self, weather: weather)
                    }else{ 
                        print("dediğim yerede hata varrr")
                    }
                }else{
                    print("dediğim yerede hata varrr")
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        
        let decoder = JSONDecoder()
        do{
          
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather?[0].id
            let temp = decodedData.main!.temp
            let name = decodedData.name
            let description = decodedData.weather![0].description
            
            let weather = WeatherModel(conditionId: id!, cityName: name!, temperature: temp!, description: description!)
            
            return weather
            
            
        } catch{
            print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}
