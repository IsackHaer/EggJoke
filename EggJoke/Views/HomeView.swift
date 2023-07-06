//
//  HomeView.swift
//  EggJoke
//
//  Created by Isack Häring on 21.06.23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: MainViewModel
    @State var show: Bool = false
    @State var selectedJoke = PresentJoke.sharedJoke
    @State var sharedIndice = 0
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            VStack {
                Image("egg-softboiled")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .position(x:300, y: 50)
                    .blur(radius: 10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            
            if vm.allJokes.isEmpty{
                ProgressView()
            } else {
                ScrollView {
                    ForEach(vm.presentJokes.indices){ indice in
                        JokeFolded(namespace: namespace, show: $show, joke: vm.presentJokes[indice], indice: indice)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    show.toggle()
                                    selectedJoke = vm.presentJokes[indice]
                                    sharedIndice = indice
                                }
                            }
                    }
                }
                
                if show {
                    JokeUnfolded(namespace: namespace, show: $show, joke: selectedJoke, indice: sharedIndice)
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
    @Namespace static var namespace
    static var previews: some View {
        HomeView()
            .environmentObject(MainViewModel())
    }
}
