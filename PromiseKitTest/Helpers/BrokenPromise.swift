//
//  BrokenPromise.swift
//  PromiseKitTest
//
//  Created by Равиль Вильданов on 28/05/2019.
//  Copyright © 2019 Vildanov. All rights reserved.
//

import Foundation
import PromiseKit

func brokenPromise<T>(method: String = #function) -> Promise<T> {
    return Promise<T>() { seal in
        let err = NSError(domain: "WeatherOrNot", code: 0, userInfo: [NSLocalizedDescriptionKey: "'\(method)' not yet implemented."])
        seal.reject(err)
    }
}
