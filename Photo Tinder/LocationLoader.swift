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

    init(location: CLLocation?, geocoder: CLGeocoder = CLGeocoder()) {
        self.location = location
        self.geocoder = geocoder
    }
    
    func load() {
        state = .loading
        
        getLocationName(location: location) { name in
            DispatchQueue.main.async {
                self.state = .loaded(name)
            }
        }
    }
    
    private func getLocationName(location: CLLocation?, completion: @escaping (String) -> Void) {
        guard let location = location else { return completion(" ") }
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first?.locality else { return completion(" ") }
            completion(placemark)
        }
    }
}
