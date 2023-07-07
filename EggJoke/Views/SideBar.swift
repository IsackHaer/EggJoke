//
//  FavoriteView.swift
//  EggJoke
//
//  Created by Isack Häring on 06.07.23.
//

import SwiftUI

struct SideBar: View {
    @EnvironmentObject private var vm: MainViewModel
    var body: some View {
        VStack{
            Rectangle()
                .frame(height: 50)
                .foregroundColor(.clear)
            List{
                Group{
                    ForEach(vm.savedJokes){ joke in
                        NavigationLink(value: joke) {
                            Text(joke.joke ?? "Joke not found")
                        }
                    }
                    
                    if vm.savedJokes.isEmpty {
                        Spacer()
                    }
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.clear.edgesIgnoringSafeArea(.all))
            .navigationDestination(for: SavedJoke.self) { joke in
                DetailView(joke: joke)
            }
            
            Toggle(isOn: $vm.isDarkMode) {
                HStack{
                    Image(systemName: !vm.isDarkMode ? "sun.max" : "moon")
                    Text(!vm.isDarkMode ? "Lightmode" : "Darkmode")
                }
                .foregroundColor(Color.accentColor)
            }
        }
        .padding()
        .frame(maxWidth: 288, maxHeight: .infinity)
        .background(Color("Shadow"))
        .cornerRadius(30)
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SideBar()
                .environmentObject(MainViewModel())
        }
    }
}
