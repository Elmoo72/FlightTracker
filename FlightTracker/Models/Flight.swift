import Foundation

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

    var color: String {
        switch self {
        case .scheduled: return "gray"
        case .boarding: return "blue"
        case .departed, .inAir: return "orange"
        case .landed, .arrived: return "green"
        case .delayed: return "red"
        case .cancelled: return "red"
        case .diverted: return "yellow"
        }
    }
}

struct Flight: Codable, Identifiable, Hashable {
    let id: UUID
    let flightNumber: String   // "SU 1234"
    let airline: String        // "Aeroflot"
    let departure: Airport
    let arrival: Airport
    let departureTime: Date
    let arrivalTime: Date
    var terminal: String?
    var gate: String?
    var status: FlightStatus
    var boardingTime: Date?
    var qrCodeData: String?

    // Delay in minutes (from API)
    var delayMinutes: Int?

    // Passenger info (optional, set by user)
    var passengerName: String?
    var seatNumber: String?
    var documentLastFour: String?

    static let mock = Flight(
        id: UUID(),
        flightNumber: "SU 1234",
        airline: "Aeroflot",
        departure: .mock,
        arrival: .mockJFK,
        departureTime: Date().addingTimeInterval(3600 * 4),
        arrivalTime: Date().addingTimeInterval(3600 * 14),
        terminal: "A",
        gate: "23",
        status: .scheduled,
        boardingTime: Date().addingTimeInterval(3600 * 3)
    )

    static let mockFlights: [Flight] = [
        Flight(
            id: UUID(),
            flightNumber: "SU 1234",
            airline: "Aeroflot",
            departure: Airport(code: "SVO", name: "Sheremetyevo", city: "Moscow"),
            arrival: Airport(code: "JFK", name: "JFK International", city: "New York"),
            departureTime: Date().addingTimeInterval(3600 * 4),
            arrivalTime: Date().addingTimeInterval(3600 * 14),
            terminal: "A",
            gate: "23",
            status: .scheduled,
            boardingTime: Date().addingTimeInterval(3600 * 3)
        ),
        Flight(
            id: UUID(),
            flightNumber: "BA 456",
            airline: "British Airways",
            departure: Airport(code: "LHR", name: "Heathrow", city: "London"),
            arrival: Airport(code: "CDG", name: "Charles de Gaulle", city: "Paris"),
            departureTime: Date().addingTimeInterval(3600 * 8),
            arrivalTime: Date().addingTimeInterval(3600 * 11),
            terminal: "5",
            gate: "B12",
            status: .boarding,
            boardingTime: Date().addingTimeInterval(3600 * 7)
        )
    ]
}
