//
//  MainViewModel.swift
//  EggJoke
//
//  Created by Isack Häring on 21.06.23.
//

import Foundation
import SwiftUI
import CoreData

@MainActor
class MainViewModel: ObservableObject {
    enum CustomError: Error {
        case invalidURL, invalidRESPONSE, invalidDATA
    }
    
    @Published var navPath = NavigationPath()
    
    @Published var repo = EggRepository()
    private var container: NSPersistentContainer
    
    var allJokes = [String]()   //all fetched jokes as String
    @Published var savedJokes = [SavedJoke]()
    @Published var presentJokes = [PresentJoke]()
    @Published var currentStoredJoke: PresentJoke = PresentJoke.sharedJoke
    
    @Published var translation = [TranslationResponse.Translation]()
    @Published var translateTO = "DE"
    @Published var textToTranslateFROM = ""
    
    @Published var errorMessage = ""
    @Published var alertOn = false
    
    init(){
        container = NSPersistentContainer(name: "JokeDataModel")
        container.loadPersistentStores{ description, error in
            if let error = error {
                fatalError("Failed to load CoreData stacks: \(error)")
            }
        }
        fetchCoreData()
    }
    
    
    //COREDATA START-------------------------------------------------------------------
    
    func storeCurrentJoke(joke: SavedJoke) {
        currentStoredJoke = PresentJoke(
            background: joke.background ?? "",
            foreground: joke.foreground ?? "",
            rotation: joke.rotation,
            joke: joke.joke ?? "")
    }
    
    func fetchCoreData(){
        let request = NSFetchRequest<SavedJoke>(entityName: "SavedJoke")
        
        do {
            savedJokes = try container.viewContext.fetch(request)
            print(savedJokes)
        } catch {
            print("Failed to fetch CoreData: \(error.localizedDescription)")
        }
    }
    
    func saveJoke(background: String, foreground: String, rotation: Int16, joke: String) {
        let newJoke = SavedJoke(context: container.viewContext)
        newJoke.background = background
        newJoke.foreground = foreground
        newJoke.rotation = rotation
        newJoke.joke = joke
        save()
    }
    
    func deleteJoke(indexSet: IndexSet){
        guard let index = indexSet.first else {
            print("Index for deleting the joke is missing.")
            return
        }
        let deleteItem = savedJokes[index]
        container.viewContext.delete(deleteItem)
        save()
    }
    
    func save(){
        do {
            try container.viewContext.save()
            fetchCoreData()
        } catch {
            print("Save error CoreData: \(error.localizedDescription)")
        }
    }
    
    //COREDATA END---------------------------------------------------------------------
    
    
    func setLanguage(lang: String){
        translateTO = lang
    }
    
    
    /**
     * Prepares and adds presentable jokes based on the provided list of jokes.
     *
     * This function takes a list of jokes and prepares them for presentation by creating
     * PresentJoke objects with random background images, foreground images, rotations,
     * and associating them with the jokes. The prepared PresentJoke objects are added to
     * the list of present jokes if they are not already present.
     *
     * @param jokes The list of jokes to be prepared and added as presentable jokes.
     */
    func prepareJokes(jokes: [String]) {
//        if allJokes.count >= 10 {
            for joke in jokes {
                let presentable = PresentJoke(background: repo.randomBackgroundImage.randomElement() ?? "egg-softboiled", foreground: repo.randomForegroundImage.randomElement() ?? "egg-softboiled", rotation: repo.randomRotation, joke: joke)
                if !presentJokes.contains(where: {$0.joke == presentable.joke}) {
                    presentJokes.append(presentable)
                }
            }
//        }
    }
    
    
    
    func getTranslation() async {
        do {
            translation = try await fetchData(generateBaseURL(TRANSLATE_URL(textToTranslateFROM, translateTO, TRANSLATE_KEY)), TranslationResponse.self).translations
        } catch {
            errorMessage = "\(error)"
            alertOn.toggle()
        }
    }
    
    func refreshJokes() async{
        allJokes.removeAll()
        presentJokes.removeAll()
        while allJokes.count < 10 {
            do {
                try await fetchJokes()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    /**
     * Fetches jokes from various URLs asynchronously and prepares them for further processing.
     *
     * This function randomly selects a URL from a dictionary of predefined joke types,
     * fetches jokes from the selected URL using asynchronous data fetch operations,
     * and prepares the fetched jokes for further processing. Depending on the selected joke type,
     * the function uses different methods for fetching and decoding the jokes.
     *
     * @throws CustomError.invalidRESPONSE If an invalid response is received from the server.
     * @throws CustomError.invalidDATA If an error occurs during decoding or the data is invalid.
     */
    func fetchJokes() async throws {
        let urlArray = [
//            "Ninja" : NINJA_URL,
            "Chuck" : CHUCK_URL,
//            "JokeAny" : JOKEANY_URL
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
        
        print(presentJokes)
    }
    
    func loadMoreJokes(lastJokeIndice: Int) async {
        guard presentJokes[lastJokeIndice].id == presentJokes.last?.id else {
            return
        }
        
        do {
            try await fetchJokes()
        } catch {
            print("Failed to load more jokes: \(error.localizedDescription)")
        }
    }
    
    
    /**
     * Generates a base URL from the provided string.
     *
     * This function takes a string representing a URL and attempts to create a URL object
     * from it. If the provided string is not a valid URL, an error is thrown and an invalid
     * URL error case is raised.
     *
     * @param url The string representation of the URL.
     * @return The generated URL object.
     * @throws CustomError.invalidURL If the provided string is not a valid URL.
     */
    func generateBaseURL(_ url: String) throws -> URL {
        guard let url = URL(string: url) else {
            print(url)
            throw CustomError.invalidURL
        }
        return url
    }
    
    
    /**
     * Generates a URLRequest object with the specified URL, API key, and header.
     *
     * This function takes a string representation of a URL, an API key, and a header,
     * and creates a URLRequest object with the provided URL. It sets the specified
     * header field using the given API key. If the URL cannot be converted into a valid
     * URL object, an error is thrown indicating an invalid URL.
     *
     * @param url The string representation of the URL.
     * @param apiKey The API key to be set in the request header.
     * @param header The header field to which the API key will be set.
     * @return The generated URLRequest object.
     * @throws CustomError.invalidURL If the provided string is not a valid URL.
     */
    func generateURLRequest(_ url: String, _ apiKey: String, _ header: String) throws -> URLRequest {
        guard let url = URL(string: url) else {
            throw CustomError.invalidURL
        }
        var request = URLRequest(url: url)
        request.setValue("\(apiKey)", forHTTPHeaderField: header)
        return request
    }
    
    
    /**
     * Fetches and decodes data from a URL using asynchronous networking and decoding.
     *
     * This function takes a URL and a decoding type conforming to the Codable protocol.
     * It performs an asynchronous data fetch operation using URLSession.shared. Upon
     * receiving the data, it attempts to decode it into the specified type using JSONDecoder.
     * If the response status code is not 200, an error is thrown indicating an invalid response.
     *
     * @param url The URL from which to fetch the data.
     * @param <T> The type to which the fetched data will be decoded.
     * @return An instance of the specified type representing the decoded data.
     * @throws CustomError.invalidURL If the provided URL is invalid.
     * @throws CustomError.invalidRESPONSE If the response status code is not 200.
     * @throws CustomError.invalidDATA If an error occurs during decoding or the data is invalid.
     */
    func fetchData<T: Codable>(_ url : URL, _ decodingType: T.Type) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let resonse = response as? HTTPURLResponse else { throw CustomError.invalidRESPONSE }
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
    
    
    /**
     * Fetches data from a URL using an asynchronous URLRequest and processes the response.
     *
     * This function takes a URLRequest object and performs an asynchronous data fetch operation
     * using URLSession.shared. Upon receiving the data and response, it processes the response,
     * and if the response status code is 200, it decodes the data into an array of NinjaJoke objects.
     * If the response status code is not 200, an error is thrown indicating an invalid response.
     *
     * @param urlRequest The URLRequest object to be used for fetching data.
     * @throws CustomError.invalidRESPONSE If the response status code is not 200.
     * @throws CustomError.invalidDATA If an error occurs during decoding or the data is invalid.
     */
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
    
    
    /**
     * Fetches a Chuck Norris joke asynchronously and returns a PresentJoke object.
     *
     * This function fetches a Chuck Norris joke using an asynchronous data fetch operation
     * with the Chuck Norris API URL. It then processes the response, and if the response
     * status code is 200, it decodes the data into a ChuckJokeResponse object and creates
     * a PresentJoke object from the decoded data. If the response status code is not 200,
     * an error is thrown indicating an invalid response.
     *
     * @return A PresentJoke object containing the fetched joke and related data.
     * @throws CustomError.invalidRESPONSE If the response status code is not 200.
     * @throws CustomError.invalidDATA If an error occurs during decoding or the data is invalid.
     */
    func fetchWidgetJoke() async throws -> PresentJoke {
        let (data, response) = try await URLSession.shared.data(from: generateBaseURL(CHUCK_URL))
        guard let response = response as? HTTPURLResponse else { throw CustomError.invalidRESPONSE }
            
        if response.statusCode == 200 {
            do {
                let decodedJoke = try JSONDecoder().decode(ChuckJokeResponse.self, from: data)
                return PresentJoke(background: repo.randomBackgroundImage.randomElement() ?? "", foreground: repo.randomForegroundImage.randomElement() ?? "", rotation: 0, joke: decodedJoke.value)
            } catch {
                print(error.localizedDescription)
                throw CustomError.invalidDATA
            }
        } else {
            print(response.statusCode)
            throw CustomError.invalidRESPONSE
        }
    }
}
