let TRANSLATE_KEY=""
let HUMOR_KEY=""
let NINJA_KEY=""

let NINJA_URL="https://api.api-ninjas.com/v1/jokes?limit=1"
let CHUCK_URL="https://api.chucknorris.io/jokes/random"
let JOKEANY_URL="https://v2.jokeapi.dev/joke/Any"

/**
 Creates a URL string for translating text using the DeepL API.
 
 This closure takes three parameters - the text to translate, the target language code,
 and the authentication key. It constructs a URL string for the DeepL API translation endpoint
 using the provided parameters.
 
 - Parameters:
   - textToTranslateFROM: The text to be translated.
   - translateTO: The target language code for translation.
   - translateKEY: The authentication key for accessing the DeepL API.
 - Returns: A URL string for the DeepL API translation endpoint with the provided parameters.
 */
let TRANSLATE_URL: (String, String, String) -> String = { textToTranslateFROM, translateTO, translateKEY in
    return "https://api-free.deepl.com/v2/translate?text=\(textToTranslateFROM)&target_lang=\(translateTO)&auth_key=\(TRANSLATE_KEY)"
}


//https://www.deepl.com/account
//https://humorapi.com/console/#Dashboard
//https://api-ninjas.com/profile


//https://sv443.net/jokeapi/v2/#wrappers
//https://api.chucknorris.io
