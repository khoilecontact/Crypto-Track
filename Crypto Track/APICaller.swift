//
//  APICaller.swift
//  Crypto Track
//
//  Created by KhoiLe on 16/10/2021.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private struct Constant {
        static let apiKey = "25F448AB-DAD7-478F-8D08-47F8BC06F826"
        //Endpoint from Sandbox - Encrypted
        static let assetsEndpoint = "https://rest-sandbox.coinapi.io/v1/assets"
    }
    
    private init() { }
    
    private var whenReadyBlock: ((Result<[Crypto], Error>) -> Void)?
    
    public var icons = [Icon]()
    
    //MARK: -Public
    
    public func getAllCryptoData(completion: @escaping (Result<[Crypto], Error>) -> Void) {
        guard !icons.isEmpty else {
            whenReadyBlock = completion
            return
        }
        
        guard let url = URL(string: Constant.assetsEndpoint + "?apikey=" + Constant.apiKey) else {
            print("Cannot convert url for api")
            return
        }
        // Send the API and get the result
        let task = URLSession.shared.dataTask(with: url) { data, urlrespone, error in
            guard let data = data, error == nil else {
                print("Error in recieving data: \(String(describing: error))")
                print("URL response: \(String(describing: urlrespone))")
                return
            }
            
            do {
                // Decode response
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                cryptos.sorted(by: {first, second in
                    return first.price_usd ?? 0 > second.price_usd ?? 0
                })
                completion(.success(cryptos))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func getAllIcon() {
        guard let url = URL(string: "https://rest-sandbox.coinapi.io/v1/assets/icons/56?apikey=25F448AB-DAD7-478F-8D08-47F8BC06F826") else {
            return
        }
        
        // Send the API and get the result
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, urlrespone, error in
            guard let data = data, error == nil else {
                print("Error in recieving icons: \(String(describing: error))")
                print("URL response: \(String(describing: urlrespone))")
                return
            }
            
            do {
                // Decode response
                self?.icons = try JSONDecoder().decode([Icon].self, from: data)
                if let completion = self?.whenReadyBlock {
                    self?.getAllCryptoData(completion: completion)
                }
            } catch {
                print(error)
            }
        }
        task.resume()

    }
}
