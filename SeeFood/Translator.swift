//
//  Translator.swift
//  SeeFood
//
//  Created by Marina Karpova on 05.02.2023.
//

import Foundation

protocol TranslatorDelegate {
    func didUpdateTranslator(_ translator: Translator, result: String)
}

class Translator: NSURLConnection {
    
    var delegate: TranslatorDelegate?

    
    //HEADERS + API !!!

    var parameters = [
        "q": "Hello World!",
        "source": "en",
        "target": "de"
    ] as [String : Any]

    var translate: String = ""
    
    func bla() {

        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])

        let request = NSMutableURLRequest(url: NSURL(string: "https://deep-translate1.p.rapidapi.com/language/translate/v2")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                
                if let safeData = data {
                    if let tr = self.parseJSON(safeData){
                        self.translate = tr
                        self.delegate?.didUpdateTranslator(self, result: tr)
                        print(tr)
                    }
                }
            }
        })

        dataTask.resume()
    }
    
    func parseJSON(_ translateData: Data) -> String? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(TranslatorData.self, from: translateData)
            let translate = decodedData.data.translations.translatedText
            
            return translate
             
        } catch {
            print(error)
            return ""
        }
    }

    
}
