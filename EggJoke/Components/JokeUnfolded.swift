//
//  JokeUnfolded.swift
//  EggJoke
//
//  Created by Isack Häring on 03.07.23.
//

import SwiftUI

struct JokeUnfolded: View {
    var namespace: Namespace.ID
    @Binding var show: Bool
    var joke: PresentJoke
    var indice: Int
    
    var body: some View {
        ZStack {
            ScrollView {
                cover
            }
            .background(Color("Background"))
            .ignoresSafeArea()
            
            Button {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    show.toggle()
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.body.weight(.bold))
                    .foregroundColor(.secondary)
                    .padding(10)
                    .background(.ultraThinMaterial, in: Circle())
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
                Button("Translate"){
                    //TODO: navigate to translateView
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
    }
}

struct JokeUnfolded_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        JokeUnfolded(namespace: namespace, show: .constant(true), joke: PresentJoke.sharedJoke, indice: 0)
    }
}
