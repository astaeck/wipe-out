//
//  LocationLoadable.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 21.02.22.
//

import CoreLocation

class LocationLoadable: LoadableObject {
    
    typealias Output = String
    @Published private(set) var state: LoadingState<String> = .idle
    private let location: CLLocation?
    private let locationLoader: LocationLoader

    init(locationLoader: LocationLoader = LocationLoader.shared,
         location: CLLocation?) {
        self.locationLoader = locationLoader
        self.location = location
    }
    
    func load() {
        state = .loading
        
        locationLoader.load(location: location) { result in
            guard let locationName = try? result.get() else { return }
            self.state = .loaded(locationName)
        }
    }
}
