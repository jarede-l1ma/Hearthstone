import Foundation
import Combine

struct CardsService: CardsServiceInterface {
    
    func fetchCards(faction: String) -> AnyPublisher<[Card], Error> {
        let urlString = "\(CardsAPI.apiURL)\(faction)"
        guard let url = URL(string: urlString) else {
            return Fail(error: NSError(domain: "Invalid URL", code: 0))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = CardsAPI.headers
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { error -> Error in
                if error.localizedDescription.contains("cancelled") {
                    return NSError(domain: "Cancelled", code: 0)
                } else {
                    return error
                }
            }
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.cancelled)
                }
                return data
            }
            .decode(type: [Card].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
