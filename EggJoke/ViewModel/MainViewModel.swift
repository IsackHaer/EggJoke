//
//  MainViewModel.swift
//  EggJoke
//
//  Created by Isack Häring on 21.06.23.
//

import Foundation

class MainViewModel: ObservableObject {

    func getAPIKey() -> String? {
        guard let filePath = Bundle.main.path(forResource: ".env", ofType: nil) else {
            print(".env not found")
            return nil
        }
        
        do {
            let contents = try String(contentsOfFile: filePath, encoding: .utf8)
            let lines = contents.components(separatedBy: .newlines)
            
            for line in lines {
                let components = line.components(separatedBy: "=")
                if components.count == 2 && components[0] == "API_KEY" {
                    return components[1]
                }
            }
        } catch {
            print("Error reading .env file: \(error)")
        }
        
        return nil
    }
    
}
