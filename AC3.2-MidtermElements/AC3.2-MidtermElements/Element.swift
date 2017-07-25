//
//  Element.swift
//  AC3.2-MidtermElements
//
//  Created by Tom Seymour on 12/8/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation

enum ElementParseError: Error {
    case accessingAPI(json: Any)
    case initializingElement(json: Any)
}

class Element {
    
    let name: String
    let number: Int
    let weight: Double
    let symbol: String
    let meltingPoint: Int?
    let boilingPoint: Int?
    let thumbnailUrlString: String
    let fullImageUrlString: String
    
    init?(from dict: [String: Any]) {
        guard let name = dict["name"] as? String,
            let number = dict["number"] as? Int,
            let weight = dict["weight"] as? Double,
            let symbol = dict["symbol"] as? String else { return nil }
        let melting = dict["melting_c"] as? Int ?? nil
        let boiling = dict["boiling_c"] as? Int ?? nil
        let thumb = "https://s3.amazonaws.com/ac3.2-elements/\(symbol)_200.png"
        let full = "https://s3.amazonaws.com/ac3.2-elements/\(symbol).png"
        
        self.name = name
        self.number = number
        self.weight = weight
        self.symbol = symbol
        self.meltingPoint = melting
        self.boilingPoint = boiling
        self.thumbnailUrlString = thumb
        self.fullImageUrlString = full
    }
    
    class func buildElementArr(from data: Data) -> [Element]? {
        
        do {
            let json: Any = try JSONSerialization.jsonObject(with: data, options: [])
            guard let elementDictArr = json as? [[String: Any]] else { throw ElementParseError.accessingAPI(json: json) }
            
            var elements: [Element] = []
            for elementDict in elementDictArr {
                if let element = Element(from: elementDict) {
                    elements.append(element)
                } else {
                    throw ElementParseError.initializingElement(json: elementDict)
                }
            }
            return elements
        }
        catch ElementParseError.accessingAPI {
            print("Error occurred while trying to accessing API")
        }
        catch ElementParseError.initializingElement {
            print("Error occurred while trying to create an instance of Element")
        }
        catch let error as NSError {
            print("Error occurred while parsing data: \(error.localizedDescription)")
        }
        return nil
    }
}
