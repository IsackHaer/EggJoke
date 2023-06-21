//
//  EggJokeApp.swift
//  EggJoke
//
//  Created by Isack Häring on 21.06.23.
//

import SwiftUI

@main
struct EggJokeApp: App {
    
    @StateObject private var vm = MainViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
        }
    }
}
