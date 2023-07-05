//
//  JokeCard.swift
//  EggJoke
//
//  Created by Isack Häring on 03.07.23.
//

import SwiftUI

struct JokeCard: View {
    var namespace: Namespace.ID
    @Binding var show: Bool
    @Binding var joke: PresentJoke
    var body: some View {
        
        ZStack{
            //            Color.accentColor.ignoresSafeArea()
            JokeFolded(namespace: namespace, show: $show, joke: $joke)
        }
    }
}

struct JokeCard_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        JokeCard(namespace: namespace ,show: .constant(false) ,joke: .constant(PresentJoke.sharedJoke))
    }
}
