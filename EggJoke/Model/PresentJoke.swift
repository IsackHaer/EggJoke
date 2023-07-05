//
//  PresentJoke.swift
//  EggJoke
//
//  Created by Isack Häring on 01.07.23.
//

import Foundation
import SwiftUI

struct PresentJoke: Identifiable {
    let id = UUID()
    let background: String
    let foreground: String
    let rotation: Int16
    let joke: String
    
    static let sharedJoke = PresentJoke(background: "blob", foreground: "egg-softboiled", rotation: 45, joke: "This is a test joke that tells us a funny joke about some kind of joke and let use a very, loooooooooooooooooooong word in aswell to see what it looks like")
}
