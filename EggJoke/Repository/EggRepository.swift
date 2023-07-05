//
//  EggRepository.swift
//  EggJoke
//
//  Created by Isack Häring on 01.07.23.
//

import Foundation

class EggRepository: ObservableObject {
    
    @Published var randomBackgroundImage = [
        "blob-scene",
        "blob",
        "blurry-gradient-purple",
        "blurry-gradient-yellow",
        "circle-shatter",
        "lavered-steps",
        "layered-waves",
        "low-poly-grid",
        "stacked-waves"
    ]
    
    @Published var randomForegroundImage = [
        "egg-lowpoly",
        "egg-softboiled",
        "egg-sunnysideup"
    ]
    
    @Published var randomRotation: Int16 = Int16.random(in: 0...360)
}
