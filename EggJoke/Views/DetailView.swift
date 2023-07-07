//
//  DetailView.swift
//  EggJoke
//
//  Created by Isack Häring on 01.07.23.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject private var vm: MainViewModel
    @State private var showSheet = false
    @State private var currentDetentSize = PresentationDetent.medium
    var joke: SavedJoke
    var body: some View {
        ZStack {
            ScrollView {
                cover
            }
            .background(Color("Background"))
            .ignoresSafeArea()
            VStack(alignment: .trailing) {
                Button {
                    vm.navPath.removeLast(vm.navPath.count)
                } label: {
                    Image(systemName: "xmark")
                        .font(.body.weight(.bold))
                        .foregroundColor(.secondary)
                        .padding(12)
                        .background(.ultraThinMaterial, in: Circle())
                }
                
                Button {
                    if vm.savedJokes.contains(where: {$0.joke == vm.currentStoredJoke.joke}) {
                        let index = vm.savedJokes.firstIndex(where: {$0.joke == vm.currentStoredJoke.joke})
                        vm.deleteJoke(indexSet: IndexSet(integer: index!))
                    } else {
                        vm.saveJoke(background: vm.currentStoredJoke.background, foreground: vm.currentStoredJoke.foreground, rotation: vm.currentStoredJoke.rotation , joke: vm.currentStoredJoke.joke)
                    }
                } label: {
                    Image(systemName: vm.savedJokes.contains(where: {$0.joke == vm.currentStoredJoke.joke}) ? "star.fill" : "star")
                        .font(.body.weight(.bold))
                        .padding(10)
                        .background(.ultraThinMaterial, in: Circle())
                        .foregroundStyle(.yellow)
                }
                .padding(.vertical)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(.vertical, 50)
            .padding(.horizontal, 20)
            .ignoresSafeArea()
            
        }
    }
    var cover: some View {
        VStack {
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 500)
        .foregroundStyle(.black)
        .background(
            Image(vm.currentStoredJoke.foreground)
                .resizable()
                .aspectRatio(contentMode: .fit)
        )
        .background(
            Image(vm.currentStoredJoke.background)
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
        .mask(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
        )
        .overlay(
            VStack(alignment: .leading, spacing: 12){
                Text(vm.currentStoredJoke.joke)
                    .font(.title2.weight(.bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                HStack {
                    Button("Translate"){
                        showSheet.toggle()
                    }
                }
            }
                .padding(20)
                .background(
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                )
                .offset(y: 250)
                .padding(20)
        )
        .sheet(isPresented: $showSheet) {
            TranslationView(joke: vm.currentStoredJoke.joke, isOpen: $showSheet)
                .presentationDetents([.medium, .large], selection: $currentDetentSize)
        }
        .onAppear{vm.storeCurrentJoke(joke: joke)}
        .navigationBarBackButtonHidden(true)
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView()
//            .environmentObject(MainViewModel())
//    }
//}
