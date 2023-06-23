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
        VStack {
            Text(TRANSLATE_KEY)
            Text(HUMOR_KEY)
            Text(NINJA_KEY)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(MainViewModel())
    }
}
