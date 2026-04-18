import Foundation

actor FlightAPIService {
    private let apiKey: String = {
        guard let key = Bundle.main.infoDictionary?["AIRLABS_API_KEY"] as? String,
              !key.isEmpty, key != "YOUR_API_KEY_HERE" else {
            return ""
        }
        return key
    }()
    private let baseURL = "https://airlabs.co/api/v9"

    enum APIError: Error, LocalizedError {
        case invalidURL
        case networkError(Error)
        case decodingError(Error)
        case noData
        case apiError(String)

        var errorDescription: String? {
            switch self {
            case .invalidURL: return "Invalid URL"
            case .networkError(let error): return "Network error: \(error.localizedDescription)"
            case .decodingError(let error): return "Decoding error: \(error.localizedDescription)"
            case .noData: return "No data received"
            case .apiError(let message): return "API error: \(message)"
            }
        }
    }

    // MARK: - Flight Tracking

    /// Fetch flight by flight number (e.g., "SU1234" or "SU 1234")
    func fetchFlight(flightNumber: String) async throws -> Flight {
        let cleanedNumber = flightNumber.replacingOccurrences(of: " ", with: "").uppercased()

        // AirLabs expects IATA code (2-letter airline code + number)
        // For example: SU1234 -> SU is airline, 1234 is flight number
        let urlString = "\(baseURL)/flight?flight_iata=\(cleanedNumber)&api_key=\(apiKey)"

        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(AirLabsResponse.self, from: data)

            guard let flightData = response.response?.first else {
                throw APIError.noData
            }

            return mapToFlight(flightData)
        } catch let error as APIError {
            throw error
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch {
            throw APIError.networkError(error)
        }
    }

    /// Fetch real-time status for a saved flight
    func fetchFlightStatus(flightNumber: String) async throws -> FlightStatus {
        let cleanedNumber = flightNumber.replacingOccurrences(of: " ", with: "").uppercased()
        let urlString = "\(baseURL)/flight?flight_iata=\(cleanedNumber)&api_key=\(apiKey)"

        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(AirLabsResponse.self, from: data)

            guard let flightData = response.response?.first else {
                throw APIError.noData
            }

            return mapToStatus(flightData.status)
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }

    // MARK: - Mapping

    private func mapToFlight(_ data: AirLabsFlightData) -> Flight {
        let departure = Airport(
            code: data.depIata ?? "---",
            name: data.depIata ?? "Unknown",
            city: data.depIata ?? "Unknown"
        )

        let arrival = Airport(
            code: data.arrIata ?? "---",
            name: data.arrIata ?? "Unknown",
            city: data.arrIata ?? "Unknown"
        )

        // Parse departure time
        let departureTime = parseDate(data.depTime) ?? Date()
        let arrivalTime = parseDate(data.arrTime) ?? Date()
        let boardingTime = departureTime.addingTimeInterval(-30 * 60) // 30 min before

        // Build airline name from airline IATA code
        let airline = airlineName(from: data.airlineIata)

        return Flight(
            id: UUID(),
            flightNumber: data.flightIata ?? data.flightNumber ?? "Unknown",
            airline: airline,
            departure: departure,
            arrival: arrival,
            departureTime: departureTime,
            arrivalTime: arrivalTime,
            terminal: data.depTerminal,
            gate: data.depGate,
            status: mapToStatus(data.status),
            boardingTime: boardingTime,
            qrCodeData: data.flightIata ?? data.flightNumber,
            delayMinutes: data.arrDelayed
        )
    }

    private func mapToStatus(_ status: String?) -> FlightStatus {
        guard let status = status?.lowercased() else { return .scheduled }

        switch status {
        case "scheduled": return .scheduled
        case "en-route", "active": return .inAir
        case "landed": return .landed
        case "delayed": return .delayed
        case "boarding": return .boarding
        case "departed": return .departed
        case "arrived": return .arrived
        case "cancelled", "canceled": return .cancelled
        case "diverted": return .diverted
        default: return .scheduled
        }
    }

    private func parseDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }

        let formatters = [
            "yyyy-MM-dd HH:mm",
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ssZ"
        ]

        for format in formatters {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }

        return nil
    }

    private func airlineName(from iata: String?) -> String {
        guard let iata = iata else { return "Unknown Airline" }

        // Common airline codes
        let airlines: [String: String] = [
            "SU": "Aeroflot",
            "S7": "S7 Airlines",
            "UT": "UTair",
            "U6": "Ural Airlines",
            "DP": "Pobeda",
            "FV": "Russia Airlines",
            "SK": "SAS",
            "BA": "British Airways",
            "LH": "Lufthansa",
            "AF": "Air France",
            "AA": "American Airlines",
            "UA": "United Airlines",
            "DL": "Delta Air Lines"
        ]

        return airlines[iata] ?? iata
    }
}

// MARK: - AirLabs API Response Models

struct AirLabsResponse: Codable {
    let response: [AirLabsFlightData]?
    let error: AirLabsError?
}

struct AirLabsError: Codable {
    let message: String?
}

struct AirLabsFlightData: Codable {
    // Flight identification
    let hex: String?
    let regNumber: String?
    let flightNumber: String?
    let flightIcao: String?
    let flightIata: String?

    // Airline
    let airlineIcao: String?
    let airlineIata: String?

    // Aircraft
    let aircraftIcao: String?
    let model: String?
    let manufacturer: String?

    // Departure
    let depIcao: String?
    let depIata: String?
    let depTerminal: String?
    let depGate: String?
    let depTime: String?
    let depTimeTs: Int?
    let depDelayed: Int?

    // Arrival
    let arrIcao: String?
    let arrIata: String?
    let arrTerminal: String?
    let arrGate: String?
    let arrBaggage: String?
    let arrTime: String?
    let arrTimeTs: Int?
    let arrDelayed: Int?

    // Status
    let status: String?

    // Real-time data
    let lat: Double?
    let lng: Double?
    let alt: Int?
    let dir: Int?
    let speed: Int?
    let vSpeed: Double?

    enum CodingKeys: String, CodingKey {
        case hex
        case regNumber = "reg_number"
        case flightNumber = "flight_number"
        case flightIcao = "flight_icao"
        case flightIata = "flight_iata"
        case airlineIcao = "airline_icao"
        case airlineIata = "airline_iata"
        case aircraftIcao = "aircraft_icao"
        case model
        case manufacturer
        case depIcao = "dep_icao"
        case depIata = "dep_iata"
        case depTerminal = "dep_terminal"
        case depGate = "dep_gate"
        case depTime = "dep_time"
        case depTimeTs = "dep_time_ts"
        case depDelayed = "dep_delayed"
        case arrIcao = "arr_icao"
        case arrIata = "arr_iata"
        case arrTerminal = "arr_terminal"
        case arrGate = "arr_gate"
        case arrBaggage = "arr_baggage"
        case arrTime = "arr_time"
        case arrTimeTs = "arr_time_ts"
        case arrDelayed = "arr_delayed"
        case status
        case lat
        case lng
        case alt
        case dir
        case speed
        case vSpeed = "v_speed"
    }
}
