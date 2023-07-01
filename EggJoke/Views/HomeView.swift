//
//  HomeView.swift
//  EggJoke
//
//  Created by Isack Häring on 21.06.23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: MainViewModel
    @State var ninjaJokes = [NinjaJokeResponse.NinjaJoke]()
    var body: some View {
        List {
            if vm.allJokes.isEmpty{
                Text("No jokes")
            } else {
                ForEach(vm.allJokes, id: \.self){ joke in
                    Text(joke)
                }
            }
        }
        .task {
            while vm.allJokes.count < 10 {
                do {
                    try await vm.fetchJokes()
                } catch {
                    print("failed again")
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(MainViewModel())
    }
}
