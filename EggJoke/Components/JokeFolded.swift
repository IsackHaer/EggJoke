//
//  JokeFolded.swift
//  EggJoke
//
//  Created by Isack Häring on 03.07.23.
//

import SwiftUI

struct JokeFolded: View {
    var namespace: Namespace.ID
    @Binding var show: Bool
    var joke: PresentJoke
    var indice: Int
    
    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading, spacing: 12) {
                Text(joke.joke)
                    .font(.title2.weight(.bold))
                    .matchedGeometryEffect(id: "title\(indice)", in: namespace)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(2)
            }
            .padding(20)
            .background(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .blur(radius: 30)
                    .matchedGeometryEffect(id: "blur\(indice)", in: namespace)
            )
        }
        .foregroundStyle(.white)
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
        .frame(height: 300)
        .padding(20)
    }
}

struct JokeFolded_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        JokeFolded(namespace: namespace, show: .constant(false), joke: PresentJoke.sharedJoke, indice: 0)
    }
}
