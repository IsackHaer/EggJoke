//
//  HomeView.swift
//  EggJoke
//
//  Created by Isack Häring on 21.06.23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: MainViewModel
    var body: some View {
        Text(API_KEY)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(MainViewModel())
    }
}
