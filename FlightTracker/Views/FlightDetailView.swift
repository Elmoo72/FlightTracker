import SwiftUI

struct FlightDetailView: View {
    let flight: Flight

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Main flight info card
                flightInfoCard

                // Gate & Terminal info
                if flight.terminal != nil || flight.gate != nil {
                    gateTerminalCard
                }

                // Boarding Pass button
                NavigationLink(destination: BoardingPassView(flight: flight)) {
                    boardingPassButton
                }

                // Flight path visualization
                flightPathCard
            }
            .padding()
        }
        .navigationTitle(flight.flightNumber)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var flightInfoCard: some View {
        VStack(spacing: 16) {
            // Status header
            HStack {
                Text(flight.airline)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                StatusBadge(status: flight.status)
            }

            // Route visualization
            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(flight.departure.code)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text(flight.departure.city)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(flight.departure.name)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }

                Spacer()

                VStack(spacing: 8) {
                    Image(systemName: "airplane")
                        .font(.title)
                        .rotationEffect(.degrees(90))

                    if let delay = flight.delayMinutes, delay > 0 {
                        Text("+\(delay) min")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(flight.arrival.code)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text(flight.arrival.city)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(flight.arrival.name)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }

            Divider()

            // Times
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Departure")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(flight.departureTime.formatted(date: .abbreviated, time: .shortened))
                        .font(.headline)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("Arrival")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(flight.arrivalTime.formatted(date: .abbreviated, time: .shortened))
                        .font(.headline)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var gateTerminalCard: some View {
        HStack(spacing: 24) {
            if let terminal = flight.terminal {
                VStack(spacing: 4) {
                    Image(systemName: "building.2")
                        .font(.title2)
                        .foregroundStyle(.blue)
                    Text("Terminal")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(terminal)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            if let gate = flight.gate {
                VStack(spacing: 4) {
                    Image(systemName: "door.left.hand.closed")
                        .font(.title2)
                        .foregroundStyle(.green)
                    Text("Gate")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(gate)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private var boardingPassButton: some View {
        HStack {
            Image(systemName: "qr.code")
                .font(.title2)
            Text("Show Boarding Pass")
                .font(.headline)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .background(Color.blue)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var flightPathCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Flight Path")
                .font(.headline)

            HStack {
                VStack(alignment: .leading) {
                    Circle()
                        .fill(.blue)
                        .frame(width: 12, height: 12)
                    Rectangle()
                        .fill(.blue.opacity(0.3))
                        .frame(width: 2, height: 40)
                    Circle()
                        .fill(.green)
                        .frame(width: 12, height: 12)
                }

                VStack(alignment: .leading, spacing: 48) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(flight.departure.code)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text(flight.departure.city)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(flight.arrival.code)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text(flight.arrival.city)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    NavigationStack {
        FlightDetailView(flight: .mock)
    }
}
