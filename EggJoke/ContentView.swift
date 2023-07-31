//
//  ContentView.swift
//  EggJoke
//
//  Created by Isack Häring on 21.06.23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var vm: MainViewModel
    @State var showForWidget = true
    var body: some View {
        @AppStorage("isDarkMode") var isDarkMode = vm.isDarkMode
        NavigationStack(path: $vm.navPath){
            HomeView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
            //                .onOpenURL { url in
            //                    guard
            //                        let scheme = url.scheme,
            //                        let host = url.host
            //                    else {
            //                        print("Invalid URL format")
            //                        return
            //                    }
            //                    guard scheme == "EggJoke" else {
            //                        print("Invalid url scheme")
            //                        return
            //                    }
            //                    vm.navPath.append(host)
            //                }
            //                .navigationDestination(for: String.self) { widgetJoke in
            //                    @Namespace var namespace
            //                    JokeFolded(namespace: namespace, show: $showForWidget, joke: PresentJoke(background: vm.repo.randomBackgroundImage.randomElement() ?? "", foreground: vm.repo.randomForegroundImage.randomElement() ?? "", rotation: 0, joke: widgetJoke), indice: 0)
            //                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MainViewModel())
    }
}
