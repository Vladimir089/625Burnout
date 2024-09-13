//
//  RaceModel.swift
//  625Burnout
//
//  Created by Владимир Кацап on 13.09.2024.
//

import Foundation


struct Race: Codable {
    var Image: Data
    var trackName: String
    var location: String
    var date: String
    var totals: [Total]
    
    init(Image: Data, trackName: String, location: String, date: String, totals: [Total]) {
        self.Image = Image
        self.trackName = trackName
        self.location = location
        self.date = date
        self.totals = totals
    }
}


struct Total: Codable {
    var pilotName: String
    var time: String
    
    init(pilotName: String, time: String) {
        self.pilotName = pilotName
        self.time = time
    }
}
