//
//  ContentView.swift
//  EggJoke
//
//  Created by Isack Häring on 21.06.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
           TranslationView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MainViewModel())
    }
}
