//
//  LocationLoader.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 19.12.21.
//

import SwiftUI
import CoreLocation

class LocationLoader: LoadableObject {

    typealias Output = String
    @Published private(set) var state: LoadingState<String> = .idle
    private let geocoder: CLGeocoder
    private let location: CLLocation?
    private let userDefaults: UserDefaults

    init(location: CLLocation?,
         geocoder: CLGeocoder = CLGeocoder(),
         userDefaults: UserDefaults = UserDefaults.standard) {
        self.location = location
        self.geocoder = geocoder
        self.userDefaults = userDefaults
    }
    
    func load() {
        state = .loading
        
        getLocationName(location: location)
    }
    
    private func getLocationName(location: CLLocation?) {
        guard let location = location else { return print("YO") }

        reverseGeocodeLocation(location: location) { name in
            DispatchQueue.main.async {
                self.state = .loaded(name)
            }
        }
    }
    
    private func reverseGeocodeLocation(location: CLLocation, completion: @escaping (String) -> Void) {
        let locationKey = "\(location.coordinate.latitude)\(location.coordinate.longitude)"
        if let cachedLocation = userDefaults.value(forKey: locationKey) as? String {
            print("cached location")
            return completion(cachedLocation)
        }
        print("reverse geocoding")
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let placemark = placemarks?.first?.locality, error == nil {
                self?.userDefaults.set(placemark, forKey: locationKey)
                return completion(placemark)
            }
            completion(" ")
            // TODO: add recursive or async queue fetching when failes
            // self?.getLocationName(location: location)
        }
    }
}
