import SwiftUI

struct AddFlightView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var flightNumber = ""
    @State private var departureCode = ""
    @State private var arrivalCode = ""
    @State private var departureTime = Date().addingTimeInterval(3600 * 24)
    @State private var arrivalTime = Date().addingTimeInterval(3600 * 28)
    @State private var passengerName = ""
    @State private var seatNumber = ""
    @State private var documentLastFour = ""

    var onAdd: (Flight) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("add_flight_section_flight_number") {
                    TextField("add_flight_flight_number_placeholder", text: $flightNumber)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                }

                Section("add_flight_section_route") {
                    TextField("add_flight_from_placeholder", text: $departureCode)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()

                    TextField("add_flight_to_placeholder", text: $arrivalCode)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                }

                Section("add_flight_section_departure") {
                    DatePicker(
                        "add_flight_date_time",
                        selection: $departureTime,
                        in: Date()...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .onChange(of: departureTime) { _, newValue in
                        if arrivalTime <= newValue {
                            arrivalTime = newValue.addingTimeInterval(3600 * 2)
                        }
                    }
                }

                Section("add_flight_section_arrival") {
                    DatePicker(
                        "add_flight_date_time",
                        selection: $arrivalTime,
                        in: departureTime...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
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
                        addFlight()
                    }
                    .disabled(!isValid)
                }
            }
            .navigationTitle("add_flight_title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var isValid: Bool {
        !flightNumber.isEmpty &&
        departureCode.count == 3 &&
        arrivalCode.count == 3 &&
        arrivalTime > departureTime
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
            departureTime: departureTime,
            arrivalTime: arrivalTime,
            terminal: nil,
            gate: nil,
            status: .scheduled,
            boardingTime: departureTime.addingTimeInterval(-30 * 60),
            qrCodeData: flightNumber.uppercased(),
            passengerName: passengerName.isEmpty ? nil : passengerName,
            seatNumber: seatNumber.isEmpty ? nil : seatNumber,
            documentLastFour: documentLastFour.isEmpty ? nil : documentLastFour
        )
        onAdd(flight)
        dismiss()
    }
}

#Preview {
    AddFlightView { _ in }
}
