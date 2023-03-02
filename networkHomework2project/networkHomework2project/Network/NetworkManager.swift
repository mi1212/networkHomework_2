//
//  NetworkManager.swift
//  networkHomework2project
//
//  Created by Mikhail Chuparnov on 01.03.2023.
//

import UIKit


final class NetworkManager {
    
    func prepareUrl(city: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: "393785e83c9c22328a8957a1cd482c04"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "ru"),
        ]
        let url = components.url!
        return url
    }
    
    func prepareIconUrl(iconId: String) -> URL {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "openweathermap.org"
        components.path = "/img/wn/\(iconId)@2x.png"
        let url = components.url!
        return url
    }
    
    func requestWeatherData(city: String, completion: @escaping (WeatherData?, ErrorMessage?) -> Void) {
        let url = prepareUrl(city: city)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let data = data {
                    
                    do {
                        let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                        completion(weatherData, nil)
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError)
                        do {
                            let errorData = try JSONDecoder().decode(ErrorMessage.self, from: data)
                            completion(nil, errorData)
                        } catch let jsonError {
                            print("Failed to decode JSON", jsonError)
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    func getIcon(iconId: String, completion: @escaping (UIImage) -> Void) {
        let url = prepareIconUrl(iconId: iconId)
        
        URLSession.shared.dataTask(with: url, completionHandler: { data, respond, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                completion(UIImage(data: data)!)
            }
        }).resume()
    }
    
}
