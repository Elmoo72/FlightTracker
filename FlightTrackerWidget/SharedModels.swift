import Foundation

struct Flight: Codable, Identifiable, Hashable {
    let id: UUID
    let flightNumber: String
    let airline: String
    let departure: Airport
    let arrival: Airport
    let departureTime: Date
    let arrivalTime: Date
    var terminal: String?
    var gate: String?
    var status: FlightStatus
    var boardingTime: Date?
    var qrCodeData: String?
    var delayMinutes: Int?
}

struct Airport: Codable, Identifiable, Hashable {
    var id: String { code }
    let code: String
    let name: String
    let city: String
}

enum FlightStatus: String, Codable, CaseIterable {
    case scheduled = "Scheduled"
    case boarding = "Boarding"
    case departed = "Departed"
    case inAir = "In Air"
    case landed = "Landed"
    case arrived = "Arrived"
    case delayed = "Delayed"
    case cancelled = "Cancelled"
    case diverted = "Diverted"
}
