//
//  TranslationView.swift
//  EggJoke
//
//  Created by Isack Häring on 21.06.23.
//

import SwiftUI

struct TranslationView: View {
    @EnvironmentObject private var vm: MainViewModel
    var joke: String
    @State private var pickerSelection: String = "DE"
    @Binding var isOpen: Bool
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            Image("egg-softboiled")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .blur(radius: 10)
            ScrollView{
                Text(joke)
                    .font(.title3.weight(.bold))
                    .padding()
                    .background(.ultraThinMaterial)
                    .mask(RoundedRectangle(cornerRadius: 30))
                    .padding()
                Picker("Language", selection: $pickerSelection) {
                    ForEach(Language.allCases) { lang in
                        Text("\(lang.rawValue)").tag(lang.rawValue)
                    }
                }
                Text(vm.translation.first?.text ?? "Nothing to translate")
                    .font(.title3.weight(.bold))
                    .padding()
                    .background(.ultraThinMaterial)
                    .mask(RoundedRectangle(cornerRadius: 30))
                    .padding()
            }
        }
        .task {
            vm.translateTO = pickerSelection
            vm.textToTranslateFROM = joke.replacingOccurrences(of: " ", with: "%20")
            await vm.getTranslation()
        }
        .onChange(of: pickerSelection, perform: { newValue in
            Task{
                vm.setLanguage(lang: newValue)
                await vm.getTranslation()
            }
        })
    }
}

struct TranslationView_Previews: PreviewProvider {
    static var previews: some View {
        TranslationView(joke: PresentJoke.sharedJoke.joke, isOpen: .constant(true))
            .environmentObject(MainViewModel())
    }
}
