//
//  MainViewModel.swift
//  EggJoke
//
//  Created by Isack Häring on 21.06.23.
//

import Foundation

@MainActor
class MainViewModel: ObservableObject {
    enum CustomError: Error {
        case invalidURL, invalidRESPONSE, invalidDATA
    }
    
    @Published var repo = EggRepository()
    
    @Published var translation = [TranslationResponse.Translation]()
    @Published var translateTO = "DE"
    @Published var textToTranslateFROM = ""
    @Published var errorMessage = ""
    @Published var alertOn = false
    
    var allJokes = [String]()
    @Published var presentJokes = [PresentJoke]()
    
    func setLanguage(lang: String){
        translateTO = lang
    }
    
    func prepareJokes(jokes: [String]) {
        if allJokes.count >= 10 {
            for joke in jokes {
                let presentable = PresentJoke(background: repo.randomBackgroundImage.randomElement() ?? "egg-softboiled", foreground: repo.randomForegroundImage.randomElement() ?? "egg-softboiled", rotation: repo.randomRotation, joke: joke)
                if !presentJokes.contains(where: {$0.joke == presentable.joke}) {
                    presentJokes.append(presentable)
                }
            }
        }
    }
    
    func getTranslation() async {
        do {
            translation = try await fetchData(generateBaseURL(TRANSLATE_URL(textToTranslateFROM, translateTO, TRANSLATE_KEY)), TranslationResponse.self).translations
        } catch {
            errorMessage = "\(error)"
            alertOn.toggle()
        }
    }
    
    func fetchJokes() async throws {
        let urlArray = [
//            "Ninja" : NINJA_URL,
            "Chuck" : CHUCK_URL,
            "JokeAny" : JOKEANY_URL
        ].randomElement()
        
        switch urlArray?.key {
        case "Ninja" :
            do {
                try await fetchDataWithURLRequest(generateURLRequest(urlArray?.value ?? "", NINJA_KEY, "X-Api-Key"))
                prepareJokes(jokes: allJokes)
            } catch {
                print(error)
            }
        case "Chuck" :
            do {
                try await allJokes.append(fetchData(generateBaseURL(urlArray?.value ?? ""), ChuckJokeResponse.self).value)
                prepareJokes(jokes: allJokes)
            } catch {
                print(error)
            }
        case "JokeAny" :
            do {
                guard let fetchedAnyJoke = try await fetchData(generateBaseURL(urlArray?.value ?? ""), JokeAnyResponse.self).joke else {
                    return
                }
                allJokes.append(fetchedAnyJoke)
                prepareJokes(jokes: allJokes)
            }
        default : print("urlArray from fetchJokes had an unexpected dictionary key of unknown...")
        }
    }
    
    func generateBaseURL(_ url: String) throws -> URL {
        guard let url = URL(string: url) else {
            print(url)
            throw CustomError.invalidURL
        }
        return url
    }
    
    func generateURLRequest(_ url: String, _ apiKey: String, _ header: String) throws -> URLRequest {
        guard let url = URL(string: url) else {
            throw CustomError.invalidURL
        }
        var request = URLRequest(url: url)
        request.setValue("\(apiKey)", forHTTPHeaderField: header)
        return request
    }
    
    func fetchData<T: Codable>(_ url : URL, _ decodingType: T.Type) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let resonse = response as? HTTPURLResponse else { throw CustomError.invalidRESPONSE}
        if resonse.statusCode == 200{
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                print(error)
                print(error.localizedDescription)
                throw CustomError.invalidDATA
            }
        } else {
            print(resonse.statusCode)
            throw CustomError.invalidRESPONSE
        }
    }
    
    func fetchDataWithURLRequest(_ urlRequest: URLRequest) async throws {
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse else { throw CustomError.invalidRESPONSE }
        if response.statusCode == 200 {
            do {
                let jokeDecoded = try JSONDecoder().decode([NinjaJokeResponse.NinjaJoke].self, from: data)
                for joke in jokeDecoded {
                    allJokes.append(joke.joke)
                }
            } catch {
                print(error)
                print(error.localizedDescription)
                throw CustomError.invalidDATA
            }
        } else {
            print(response.statusCode)
            throw CustomError.invalidRESPONSE
        }
    }
}
