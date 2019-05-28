//
//  LocationManager.swift
//  PromiseKitTest
//
//  Created by Равиль Вильданов on 23/04/2019.
//  Copyright © 2019 Vildanov. All rights reserved.
//

import Foundation
import CoreLocation
import PromiseKit

class LocationManager {
    
    func currentLocation() -> Promise<CLPlacemark> {
        return CLLocationManager.requestLocation().lastValue.then { location in
            return CLGeocoder().reverseGeocode(location: location).firstValue
        }
    }

    func searchForPlacemark(text: String) -> Promise<CLPlacemark> {
        return CLGeocoder().geocode(text).firstValue
    }
}
