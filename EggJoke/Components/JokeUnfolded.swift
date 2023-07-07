//
//  JokeUnfolded.swift
//  EggJoke
//
//  Created by Isack Häring on 03.07.23.
//

import SwiftUI

struct JokeUnfolded: View {
    @EnvironmentObject private var vm: MainViewModel
    var namespace: Namespace.ID
    @Binding var show: Bool
    var joke: PresentJoke
    var indice: Int
    @State private var showSheet = false
    @State private var currentDetentSize = PresentationDetent.medium
    
    var body: some View {
        ZStack {
            ScrollView {
                cover
            }
            .background(Color("Background"))
            .ignoresSafeArea()
            VStack(alignment: .trailing) {
                Button {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        show.toggle()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.body.weight(.bold))
                        .foregroundColor(.secondary)
                        .padding(12)
                        .background(.ultraThinMaterial, in: Circle())
                }
                
                Button {
                    if vm.savedJokes.contains(where: {$0.joke == joke.joke}) {
                        let index = vm.savedJokes.firstIndex(where: {$0.joke == joke.joke})
                        vm.deleteJoke(indexSet: IndexSet(integer: index!))
                    } else {
                        vm.saveJoke(background: joke.background, foreground: joke.foreground, rotation: joke.rotation, joke: joke.joke)
                    }
                } label: {
                    Image(systemName: vm.savedJokes.contains(where: {$0.joke == joke.joke}) ? "star.fill" : "star")
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
            Image(joke.foreground)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .matchedGeometryEffect(id: "foreground\(indice)", in: namespace)
        )
        .background(
            Image(joke.background)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .matchedGeometryEffect(id: "background\(indice)", in: namespace)
        )
        .mask(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .matchedGeometryEffect(id: "mask\(indice)", in: namespace)
        )
        .overlay(
            VStack(alignment: .leading, spacing: 12){
                Text(joke.joke)
                    .font(.title2.weight(.bold))
                    .matchedGeometryEffect(id: "title\(indice)", in: namespace)
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
                        .matchedGeometryEffect(id: "blur\(indice)", in: namespace)
                )
                .offset(y: 250)
                .padding(20)
        )
        .sheet(isPresented: $showSheet) {
            TranslationView(joke: joke.joke, isOpen: $showSheet)
                .presentationDetents([.medium, .large], selection: $currentDetentSize)
        }
    }
}

struct JokeUnfolded_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        JokeUnfolded(namespace: namespace, show: .constant(true), joke: PresentJoke.sharedJoke, indice: 0)
            .environmentObject(MainViewModel())
    }
}
