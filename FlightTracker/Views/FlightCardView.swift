import SwiftUI

struct FlightCardView: View {
    let flight: Flight

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header: Flight number + Status
            HStack {
                Text(flight.flightNumber)
                    .font(.headline)
                    .fontWeight(.bold)

                Spacer()

                StatusBadge(status: flight.status)
            }

            // Route
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(flight.departure.code)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(flight.departure.city)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(spacing: 4) {
                    Image(systemName: "airplane")
                        .font(.title3)
                        .foregroundStyle(.blue)

                    Rectangle()
                        .fill(.quaternary)
                        .frame(width: 60, height: 1)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(flight.arrival.code)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(flight.arrival.city)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()

            // Bottom: Time + Gate/Terminal
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Departure")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                    Text(flight.departureTime.formatted(date: .omitted, time: .shortened))
                        .font(.subheadline)
                        .fontWeight(.medium)
                }

                Spacer()

                if let terminal = flight.terminal, let gate = flight.gate {
                    HStack(spacing: 16) {
                        VStack(spacing: 2) {
                            Text("Terminal")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                            Text(terminal)
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }

                        VStack(spacing: 2) {
                            Text("Gate")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                            Text(gate)
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("Arrival")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                    Text(flight.arrivalTime.formatted(date: .omitted, time: .shortened))
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct StatusBadge: View {
    let status: FlightStatus

    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.15))
            .foregroundStyle(statusColor)
            .clipShape(Capsule())
    }

    private var statusColor: Color {
        switch status {
        case .scheduled: return .gray
        case .boarding: return .blue
        case .departed, .inAir: return .orange
        case .landed, .arrived: return .green
        case .delayed, .cancelled: return .red
        case .diverted: return .yellow
        }
    }
}

#Preview {
    FlightCardView(flight: .mock)
        .padding()
}
