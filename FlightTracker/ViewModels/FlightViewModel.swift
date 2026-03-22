import Foundation
import Combine

@MainActor
final class FlightViewModel: ObservableObject {
    @Published var flights: [Flight] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let userDefaultsKey = "savedFlights"

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
