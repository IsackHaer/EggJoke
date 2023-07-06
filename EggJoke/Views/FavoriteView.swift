//
//  FavoriteView.swift
//  EggJoke
//
//  Created by Isack Häring on 06.07.23.
//

import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject private var vm: MainViewModel
    var body: some View {
        VStack{
            
        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
            .environmentObject(MainViewModel())
    }
}
