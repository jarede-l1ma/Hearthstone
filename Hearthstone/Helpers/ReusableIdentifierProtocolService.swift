/// A `extension` so that we can present them in reusable identifier from `ReusableIdentifierProtocolService`

protocol ReusableIdentifierProtocolService {
    
    static var reusableIdentifier: String { get }
    
}

extension ReusableIdentifierProtocolService {
    
    static var reusableIdentifier: String {
        
        return String(describing: Self.self)
        
    }
}
