//
//  TranslationView.swift
//  EggJoke
//
//  Created by Isack Häring on 21.06.23.
//

import SwiftUI

struct TranslationView: View {
    @EnvironmentObject private var vm: MainViewModel
    var body: some View {
        VStack{
            Text(vm.translation.first?.text ?? "no text")
            Button("click me"){
                vm.textToTranslateFROM = "This is a test".replacingOccurrences(of: " ", with: "%20")
            }
            Button("Translate"){
                vm.translation = []
                Task {
                    await vm.fillTranslationList()
                }
            }
        }
        .task {
            await vm.fillTranslationList()
        }
    }
}

struct TranslationView_Previews: PreviewProvider {
    static var previews: some View {
        TranslationView()
            .environmentObject(MainViewModel())
    }
}
