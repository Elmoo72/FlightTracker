import SwiftUI

private enum AddStep {
    case search
    case confirm(Flight)
}

struct AddFlightView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var flightNumber = ""
    @State private var step: AddStep = .search
    @State private var isLoading = false
    @State private var errorMessage: String?

    // Passenger info (optional, step 2)
    @State private var passengerName = ""
    @State private var seatNumber = ""
    @State private var documentLastFour = ""

    var onAdd: (Flight) -> Void

    private let apiService = FlightAPIService()

    var body: some View {
        NavigationStack {
            switch step {
            case .search:
                searchView
            case .confirm(let flight):
                confirmView(flight: flight)
            }
        }
    }

    // MARK: - Search Step

    private var searchView: some View {
        Form {
            Section {
                HStack {
                    TextField("add_flight_flight_number_placeholder", text: $flightNumber)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .submitLabel(.search)
                        .onSubmit { searchFlight() }

                    if isLoading {
                        ProgressView()
                    }
                }
            } header: {
                Text("add_flight_section_flight_number")
            } footer: {
                Text("add_flight_search_hint")
                    .foregroundStyle(.secondary)
            }

            if let error = errorMessage {
                Section {
                    Label(error, systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.red)
                }
            }

            Section {
                Button("add_flight_search_button") {
                    searchFlight()
                }
                .disabled(flightNumber.trimmingCharacters(in: .whitespaces).isEmpty || isLoading)
            }
        }
        .navigationTitle("add_flight_title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("cancel") { dismiss() }
            }
        }
    }

    // MARK: - Confirm Step

    private func confirmView(flight: Flight) -> some View {
        Form {
            Section("add_flight_section_found") {
                flightPreviewRow(flight: flight)
            }

            Section("add_flight_section_passenger") {
                TextField("add_flight_full_name", text: $passengerName)
                TextField("add_flight_seat_placeholder", text: $seatNumber)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                TextField("add_flight_doc_placeholder", text: $documentLastFour)
                    .keyboardType(.numberPad)
            }

            Section {
                Button("add_flight_button") {
                    var final = flight
                    final.passengerName = passengerName.isEmpty ? nil : passengerName
                    final.seatNumber = seatNumber.isEmpty ? nil : seatNumber
                    final.documentLastFour = documentLastFour.isEmpty ? nil : documentLastFour
                    onAdd(final)
                    dismiss()
                }
            }
        }
        .navigationTitle("add_flight_confirm_title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("add_flight_back") {
                    withAnimation { step = .search }
                }
            }
        }
    }

    private func flightPreviewRow(flight: Flight) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(flight.flightNumber)
                    .font(.headline)
                Spacer()
                Text(flight.airline)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 4) {
                VStack(alignment: .leading) {
                    Text(AirportDatabase.displayName(for: flight.departure.code))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(flight.departureTime.formatted(date: .omitted, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)

                VStack(alignment: .trailing) {
                    Text(AirportDatabase.displayName(for: flight.arrival.code))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(flight.arrivalTime.formatted(date: .omitted, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            HStack {
                if let terminal = flight.terminal {
                    Label(terminal, systemImage: "building.2")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                if let gate = flight.gate {
                    Label(gate, systemImage: "door.right.hand.open")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(flight.departureTime.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }

    // MARK: - Search Logic

    private func searchFlight() {
        let trimmed = flightNumber.trimmingCharacters(in: .whitespaces).uppercased()
        guard !trimmed.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let flight = try await apiService.fetchFlight(flightNumber: trimmed)
                await MainActor.run {
                    isLoading = false
                    withAnimation { step = .confirm(flight) }
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    AddFlightView { _ in }
}
