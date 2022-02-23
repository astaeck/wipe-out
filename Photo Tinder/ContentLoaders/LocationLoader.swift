//
//  LocationLoader.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 19.12.21.
//

import SwiftUI
import CoreLocation

class LocationLoader {

    private let geocoder: CLGeocoder
    private let cache = Cache<String, String>()
    typealias Handler = (Result<String, Error>) -> Void

    init(geocoder: CLGeocoder = CLGeocoder()) {
        self.geocoder = geocoder
    }
    
    static let shared = LocationLoader()
    
    func load(location: CLLocation?, completion: @escaping Handler) {
        guard let location = location else { return print("YO") }

        reverseGeocodeLocation(location: location) { name in
            DispatchQueue.main.async {
                completion(.success(name))
            }
        }
    }
    
    private func reverseGeocodeLocation(location: CLLocation, completion: @escaping (String) -> Void) {
        let locationKey = "\(location.coordinate.latitude)\(location.coordinate.longitude)"
        if let cachedLocation = cache[locationKey] {
            print("cached geocoding")
            return completion(cachedLocation)
        }
        print("reverse geocoding")
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let placemark = placemarks?.first?.locality, error == nil {
                self?.cache[locationKey] = placemark
                return completion(placemark)
            }
            return completion(" ")
            // TODO: add recursive or async queue fetching when failes
            // self?.getLocationName(location: location)
        }
    }
}


// make lightweight wrapper for access locationloader and cache singleton for one specific location
