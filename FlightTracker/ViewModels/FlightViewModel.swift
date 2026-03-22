import Foundation
import Combine

@MainActor
final class FlightViewModel: ObservableObject {
    @Published var flights: [Flight] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let userDefaultsKey = "savedFlights"
    private let apiService = FlightAPIService()

    init() {
        loadFlights()
    }

    func loadFlights() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let savedFlights = try? JSONDecoder().decode([Flight].self, from: data) else {
            flights = Flight.mockFlights
            return
        }
        flights = savedFlights.sorted { $0.departureTime < $1.departureTime }
    }

    func saveFlights() {
        guard let data = try? JSONEncoder().encode(flights) else { return }
        UserDefaults.standard.set(data, forKey: userDefaultsKey)
    }

    func addFlight(_ flight: Flight) {
        flights.append(flight)
        flights.sort { $0.departureTime < $1.departureTime }
        saveFlights()
    }

    func deleteFlight(_ flight: Flight) {
        flights.removeAll { $0.id == flight.id }
        saveFlights()
    }

    func deleteFlights(at offsets: IndexSet) {
        flights.remove(atOffsets: offsets)
        saveFlights()
    }

    func updateFlightStatus(_ flight: Flight, status: FlightStatus) {
        guard let index = flights.firstIndex(where: { $0.id == flight.id }) else { return }
        flights[index].status = status
        saveFlights()
    }

    // MARK: - Refresh

    func refreshFlights() async {
        isLoading = true
        errorMessage = nil

        do {
            for i in flights.indices {
                let flight = flights[i]
                let status = try await apiService.fetchFlightStatus(flightNumber: flight.flightNumber)
                flights[i].status = status
            }
            saveFlights()
        } catch {
            errorMessage = "Не удалось обновить: \(error.localizedDescription)"
        }

        isLoading = false
    }

    // MARK: - Time Helpers

    func timeUntilDeparture(_ flight: Flight) -> String {
        let now = Date()
        let interval = flight.departureTime.timeIntervalSince(now)

        if interval < 0 {
            return "Вылетел"
        }

        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60

        if hours > 24 {
            let days = hours / 24
            return "Через \(days) д \(hours % 24)ч"
        } else if hours > 0 {
            return "Через \(hours)ч \(minutes)мин"
        } else {
            return "Через \(minutes)мин"
        }
    }

    func timeUntilBoarding(_ flight: Flight) -> String? {
        guard let boardingTime = flight.boardingTime else { return nil }
        let now = Date()
        let interval = boardingTime.timeIntervalSince(now)

        if interval < 0 {
            return "Посадка началась"
        }

        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60

        if hours > 0 {
            return "Посадка через \(hours)ч \(minutes)мин"
        } else {
            return "Посадка через \(minutes)мин"
        }
    }

    func isFlightToday(_ flight: Flight) -> Bool {
        Calendar.current.isDateInToday(flight.departureTime)
    }

    // MARK: - Demo Data

    func loadMockData() {
        flights = Flight.mockFlights
        saveFlights()
    }

    func clearAllFlights() {
        flights = []
        saveFlights()
    }
}
