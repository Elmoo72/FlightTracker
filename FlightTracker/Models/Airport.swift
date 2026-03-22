import Foundation

struct Airport: Codable, Identifiable, Hashable {
    var id: String { code }
    let code: String      // IATA code: "SVO", "JFK"
    let name: String      // "Sheremetyevo International"
    let city: String      // "Moscow"

    static let mock = Airport(code: "SVO", name: "Sheremetyevo International", city: "Moscow")
    static let mockJFK = Airport(code: "JFK", name: "John F. Kennedy International", city: "New York")
}
