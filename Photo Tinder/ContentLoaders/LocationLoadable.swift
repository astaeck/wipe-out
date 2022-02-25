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
    private let card: Card
    private let locationLoader: LocationLoader

    init(locationLoader: LocationLoader = LocationLoader.shared,
         card: Card) {
        self.locationLoader = locationLoader
        self.card = card
    }
    
    func load() {
        state = .loading
        
        locationLoader.load(card: card) { result in
            guard let locationName = try? result.get() else { return }
            self.state = .loaded(locationName)
        }
    }
}
