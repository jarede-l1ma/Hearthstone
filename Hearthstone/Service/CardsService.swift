//
//  CardsService.swift
//  Hearthstone
//
//  Created by Jarede Lima on 30/04/24.
//

import Foundation

struct CardsService: CardsServiceProtocol {
    func fetchCards(faction: String, completion: @escaping (Result<[Card], Error>) -> Void) {
        let urlString = "\(CardsAPI.apiURL)\(faction)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = CardsAPI.headers
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "HTTPError", code: 0)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode([Card].self, from: data)
                
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
