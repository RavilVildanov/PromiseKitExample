//
//  WeatherAPI.swift
//  PromiseKitTest
//
//  Created by Равиль Вильданов on 29/04/2019.
//  Copyright © 2019 Vildanov. All rights reserved.
//

import Foundation
import PromiseKit

class WeatherService {
    
    private let appID = "e61077771960c6d8d4d67d0c3bc7c638"
    
    func weather(atLatitude latitude: Double, longitude: Double) -> Promise<WeatherInfo> {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=" +
        "\(latitude)&lon=\(longitude)&appid=\(appID)"
        let url = URL(string: urlString)!
        
        return firstly {
            URLSession.shared.dataTask(.promise, with: url)
        }.compactMap {
            return try JSONDecoder().decode(WeatherInfo.self, from: $0.data)
        }
    }
    
    func weatherFor(cityName: String) -> Promise<WeatherInfo> {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(appID)"
        let url = URL(string: urlString)!
        
        return Promise { seal in
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    seal.reject(error)
                    return
                }
                
                guard let data = data else {
                    seal.reject(NetworkError.unexpectedError)
                    return
                }
                
                do {
                    let weatherInfo = try JSONDecoder().decode(WeatherInfo.self, from: data)
                    seal.fulfill(weatherInfo)
                } catch {
                    seal.reject(error)
                }
            }
        }
    }

    func getIcon(named iconName: String) -> Promise<UIImage> {
        let urlString = "http://openweathermap.org/img/w/\(iconName).png"
        let url = URL(string: urlString)!

        return firstly {
            URLSession.shared.dataTask(.promise, with: url)
        }.then(on: DispatchQueue.global(qos: .background)) { urlResponse in
            Promise.value(UIImage(data: urlResponse.data)!)
        }
    }
}

enum NetworkError: Error {
    case unexpectedError
}
