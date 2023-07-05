//
//  TestView.swift
//  EggJoke
//
//  Created by Isack Häring on 03.07.23.
//

import SwiftUI

struct TestView: View {
    @State var show = false
    @Namespace var namespace
    var joke: PresentJoke
    var body: some View {
        ZStack{
            if !show {
                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 12) {
                        Text(joke.joke)
                            .font(.title2.weight(.bold))
                            .matchedGeometryEffect(id: "title", in: namespace)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(2)
                    }
                    .padding(20)
                    .background(
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            .blur(radius: 30)
                            .matchedGeometryEffect(id: "blur", in: namespace)
                    )
                    
                }
                .foregroundStyle(.white)
                .background(
                    Image(joke.foreground)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .matchedGeometryEffect(id: "foreground", in: namespace)
                )
                .background(
                    Image(joke.background)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .matchedGeometryEffect(id: "background", in: namespace)
                )
                .mask(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .matchedGeometryEffect(id: "mask", in: namespace)
                )
                .frame(height: 300)
                .padding(20)
                
                
                
            } else {
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
                    .padding(20)
                    .ignoresSafeArea()
                    
                }
            }
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                show.toggle()
            }
        }
    }
    var cover: some View {
        VStack {
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 900)
        .foregroundStyle(.black)
        .background(
            Image(joke.foreground)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .matchedGeometryEffect(id: "foreground", in: namespace)
        )
        .background(
            Image(joke.background)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .matchedGeometryEffect(id: "background", in: namespace)
        )
        .mask(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .matchedGeometryEffect(id: "mask", in: namespace)
        )
        .overlay(
            VStack(alignment: .leading, spacing: 12){
                Text(joke.joke)
                    .font(.title2.weight(.bold))
                    .matchedGeometryEffect(id: "title", in: namespace)
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
                        .matchedGeometryEffect(id: "blur", in: namespace)
                )
//                .offset(y: 250)
                .padding(20)
        )
    }
}


struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView(joke: PresentJoke.sharedJoke)
    }
}
