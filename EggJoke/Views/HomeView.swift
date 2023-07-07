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
    @State private var isOpen = false
    var body: some View {
        ZStack {
            Color("Shadow").ignoresSafeArea()
            
            SideBar()
                .opacity(isOpen ? 1 : 0)
                .offset(x: isOpen ? 0 : -300)
                .rotation3DEffect(.degrees(isOpen ? 0 : 30), axis: (x: 0, y: 1, z: 0))
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
                        Rectangle()
                            .frame(height: 80)
                            .foregroundColor(Color.clear)
                        ForEach(vm.presentJokes.indices, id: \.self){ indice in
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
            .cornerRadius(isOpen ? 30 : 0)
            .rotation3DEffect(.degrees(isOpen ? 30 : 0), axis: (x: 0, y: -1, z: 0))
            .offset(x: isOpen ? 265 : 0)
            .scaleEffect(isOpen ? 0.9 : 1)
            .ignoresSafeArea()
            .task {
                while vm.allJokes.count < 10 {
                    do {
                        try await vm.fetchJokes()
                    } catch {
                        print("failed again")
                    }
                }
            }
            if !show {
                Button {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        isOpen.toggle()
                    }
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.body.weight(.bold))
                        .padding()
                        .background(.ultraThinMaterial, in: Circle())
                }
                .foregroundStyle(Color.accentColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .offset(x: isOpen ? 225 : 0)
                .padding()
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        NavigationStack {
            HomeView()
                .environmentObject(MainViewModel())
        }
    }
}
