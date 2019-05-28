//
//  ViewController.swift
//  PromiseKitTest
//
//  Created by Равиль Вильданов on 23/04/2019.
//  Copyright © 2019 Vildanov. All rights reserved.
//

import UIKit
import PromiseKit

class ViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    let locationManager = LocationManager()
    let weatherService = WeatherService()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestLocation()
    }
    
    private func requestLocation() {
        firstly {
            locationManager.currentLocation()
        }.done { [weak self] placemark in
            guard let self = self else { return }
            self.locationLabel.text = placemark.locality
            self.fetchWeather(for: placemark.location!.coordinate)
        }.catch { [weak self] error in
            guard let self = self else { return }
            self.locationLabel.text = error.localizedDescription
        }
    }
    
    private func fetchWeather(for coordinats: CLLocationCoordinate2D) {
        firstly {
            weatherService.weather(atLatitude: coordinats.latitude, longitude: coordinats.longitude)
        }.then { [weak self] weatherInfo -> Promise<UIImage> in
            guard let self = self else { return brokenPromise() }
            self.updateWith(weatherInfo: weatherInfo)
            return self.weatherService.getIcon(named: weatherInfo.weather.first!.icon)
        }.done { [weak self] image in
            self?.imageView.image = image
        }.catch { [weak self] error in
            self?.locationLabel.text = error.localizedDescription
        }
    }
    
    private func updateWith(weatherInfo: WeatherInfo) {
        let tempMeasurement = Measurement(value: weatherInfo.main.temp, unit: UnitTemperature.kelvin)
        let formatter = MeasurementFormatter()
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        formatter.numberFormatter = numberFormatter
        let tempStr = formatter.string(from: tempMeasurement)
        
        tempLabel.text = tempStr
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        searchTextField.resignFirstResponder()
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let text = textField.text else { return false }

        firstly {
            locationManager.searchForPlacemark(text: text)
        }.done { [weak self] placemark in
            self?.locationLabel.text = placemark.locality
            self?.fetchWeather(for: placemark.location!.coordinate)
        }.catch { [weak self] error in
            self?.locationLabel.text = error.localizedDescription
        }

        return true
    }
}
