import Foundation

actor FlightAPIService {
    // AviationStack API (free tier: 100 requests/month)
    // Get your API key at: https://aviationstack.com/
    private let apiKey = "YOUR_API_KEY_HERE"
    private let baseURL = "http://api.aviationstack.com/v1"

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
        let urlString = "\(baseURL)/flights?access_key=\(apiKey)&flight_iata=\(cleanedNumber)"

        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(AviationStackResponse.self, from: data)

            guard response.data != nil, let flightData = response.data?.first else {
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
    func fetchFlightStatus(flightNumber: String, date: Date) async throws -> FlightStatus {
        let cleanedNumber = flightNumber.replacingOccurrences(of: " ", with: "").uppercased()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "Y-MM-dd"
        let dateString = dateFormatter.string(from: date)

        let urlString = "\(baseURL)/flights?access_key=\(apiKey)&flight_iata=\(cleanedNumber)&flight_date=\(dateString)"

        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(AviationStackResponse.self, from: data)

            guard let flightData = response.data?.first else {
                throw APIError.noData
            }

            return mapToStatus(flightData)
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }

    // MARK: - Mapping

    private func mapToFlight(_ data: AviationStackFlightData) -> Flight {
        let departure = Airport(
            code: data.departure?.iata ?? "---",
            name: data.departure?.airport ?? "Unknown",
            city: data.departure?.timezone ?? "Unknown"
        )

        let arrival = Airport(
            code: data.arrival?.iata ?? "---",
            name: data.arrival?.airport ?? "Unknown",
            city: data.arrival?.timezone ?? "Unknown"
        )

        let departureTime = ISO8601DateFormatter().date(from: data.departure?.estimated ?? data.departure?.scheduled ?? "") ?? Date()
        let arrivalTime = ISO8601DateFormatter().date(from: data.arrival?.estimated ?? data.arrival?.scheduled ?? "") ?? Date()
        let boardingTime = departureTime.addingTimeInterval(-30 * 60) // 30 min before

        return Flight(
            id: UUID(),
            flightNumber: data.flight?.iata ?? "Unknown",
            airline: data.airline?.name ?? "Unknown",
            departure: departure,
            arrival: arrival,
            departureTime: departureTime,
            arrivalTime: arrivalTime,
            terminal: data.departure?.terminal,
            gate: data.departure?.gate,
            status: mapToStatus(data),
            boardingTime: boardingTime,
            qrCodeData: data.flight?.iata,
            delayMinutes: data.departure?.delay
        )
    }

    private func mapToStatus(_ data: AviationStackFlightData) -> FlightStatus {
        let status = data.flight?.status?.lowercased() ?? ""

        if status.contains("cancel") {
            return .cancelled
        } else if status.contains("active") || status.contains("en-route") {
            return .inAir
        } else if status.contains("landed") {
            return .landed
        } else if status.contains("delayed") {
            return .delayed
        } else if status.contains("boarding") {
            return .boarding
        } else if status.contains("departed") {
            return .departed
        } else if status.contains("scheduled") {
            return .scheduled
        }

        return .scheduled
    }
}

// MARK: - API Response Models

struct AviationStackResponse: Codable {
    let data: [AviationStackFlightData]?
}

struct AviationStackFlightData: Codable {
    let flight: FlightInfo?
    let airline: AirlineInfo?
    let departure: AirportInfo?
    let arrival: AirportInfo?
}

struct FlightInfo: Codable {
    let iata: String?
    let status: String?
}

struct AirlineInfo: Codable {
    let name: String?
}

struct AirportInfo: Codable {
    let iata: String?
    let airport: String?
    let scheduled: String?
    let estimated: String?
    let actual: String?
    let terminal: String?
    let gate: String?
    let delay: Int?
    let timezone: String?
}
