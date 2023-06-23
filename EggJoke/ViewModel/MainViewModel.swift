//
//  MainViewModel.swift
//  EggJoke
//
//  Created by Isack Häring on 21.06.23.
//

import Foundation

class MainViewModel: ObservableObject {
    enum EJError: Error {
        case invalidURL, invalidRESPONSE, invalidDATA
    }
    
    @Published var translation = [TranslationResponse.Translation]()
    @Published var translateTO = "DE"
    @Published var textToTranslateFROM = ""
    @Published var errorMessage = ""
    @Published var alertOn = false
    
    func fillTranslationList() async {
        do {
            translation = try await fetchTranslation().translations
        } catch {
            errorMessage = "\(error)"
            alertOn.toggle()
        }
    }
    
    func fetchTranslation() async throws -> TranslationResponse {
        guard let url = URL(string: "https://api-free.deepl.com/v2/translate?text=\(textToTranslateFROM)&target_lang=\(translateTO)&auth_key=\(TRANSLATE_KEY)") else {
            throw EJError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let resonse = response as? HTTPURLResponse else { throw EJError.invalidRESPONSE}
        if resonse.statusCode == 200{
            do {
                return try JSONDecoder().decode(TranslationResponse.self, from: data)
            } catch {
                throw EJError.invalidDATA
            }
        } else {
            print(resonse.statusCode)
            throw EJError.invalidRESPONSE
        }
    }
}
