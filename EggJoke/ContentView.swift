//
//  ContentView.swift
//  EggJoke
//
//  Created by Isack Häring on 21.06.23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var vm: MainViewModel
    var body: some View {
        @AppStorage("isDarkMode") var isDarkMode = vm.isDarkMode
        NavigationStack(path: $vm.navPath){
            HomeView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MainViewModel())
    }
}
