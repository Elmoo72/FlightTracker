import SwiftUI

struct AddFlightView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var flightNumber = ""
    @State private var departureCode = ""
    @State private var arrivalCode = ""

    var onAdd: (Flight) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Flight Number") {
                    TextField("e.g., SU 1234", text: $flightNumber)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                }

                Section("Route") {
                    TextField("From (e.g., SVO)", text: $departureCode)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()

                    TextField("To (e.g., JFK)", text: $arrivalCode)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                }

                Section {
                    Button("Add Flight") {
                        addFlight()
                    }
                    .disabled(!isValid)
                }
            }
            .navigationTitle("Add Flight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var isValid: Bool {
        !flightNumber.isEmpty && departureCode.count == 3 && arrivalCode.count == 3
    }

    private func addFlight() {
        let flight = Flight(
            id: UUID(),
            flightNumber: flightNumber.uppercased(),
            airline: "Unknown Airline",
            departure: Airport(
                code: departureCode.uppercased(),
                name: departureCode.uppercased(),
                city: departureCode.uppercased()
            ),
            arrival: Airport(
                code: arrivalCode.uppercased(),
                name: arrivalCode.uppercased(),
                city: arrivalCode.uppercased()
            ),
            departureTime: Date().addingTimeInterval(3600 * 24),
            arrivalTime: Date().addingTimeInterval(3600 * 28),
            terminal: nil,
            gate: nil,
            status: .scheduled,
            boardingTime: nil,
            qrCodeData: nil
        )
        onAdd(flight)
        dismiss()
    }
}

#Preview {
    AddFlightView { _ in }
}
