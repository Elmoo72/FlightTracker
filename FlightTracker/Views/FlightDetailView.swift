import SwiftUI

struct FlightDetailView: View {
    let flight: Flight
    @State private var currentTime = Date()

    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Countdown card
                countdownCard

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
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }

    private var countdownCard: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("До вылета")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(timeUntilDeparture)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(departureColor)
                }

                Spacer()

                Image(systemName: "airplane.departure")
                    .font(.largeTitle)
                    .foregroundStyle(.blue)
            }

            Divider()

            if let boarding = timeUntilBoarding {
                HStack {
                    Image(systemName: "door.left.hand.open")
                        .foregroundStyle(.orange)
                    Text(boarding)
                        .font(.headline)
                    Spacer()
                }
            }

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.tertiarySystemFill))
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(progressColor)
                        .frame(width: geometry.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)

            HStack {
                Text("Сейчас")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Посадка")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Вылет")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
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
                        Text("+\(delay) мин")
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

    // MARK: - Helpers

    private var timeUntilDeparture: String {
        let interval = flight.departureTime.timeIntervalSince(currentTime)
        if interval < 0 { return "Вылетел" }

        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60

        if hours > 24 {
            let days = hours / 24
            return "\(days)д \(hours % 24)ч"
        } else if hours > 0 {
            return "\(hours)ч \(minutes)мин"
        } else {
            return "\(minutes)мин"
        }
    }

    private var timeUntilBoarding: String? {
        guard let boardingTime = flight.boardingTime else { return nil }
        let interval = boardingTime.timeIntervalSince(currentTime)
        if interval < 0 { return "Посадка началась" }

        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60

        if hours > 0 {
            return "Посадка через \(hours)ч \(minutes)мин"
        } else {
            return "Посадка через \(minutes)мин"
        }
    }

    private var progress: CGFloat {
        guard let boardingTime = flight.boardingTime else { return 0 }

        let totalDuration = flight.departureTime.timeIntervalSince(boardingTime)
        let elapsed = currentTime.timeIntervalSince(boardingTime)

        let p = CGFloat(elapsed / totalDuration)
        return min(max(p, 0), 1)
    }

    private var departureColor: Color {
        let interval = flight.departureTime.timeIntervalSince(currentTime)
        if interval < 3600 { return .red } // Less than 1 hour
        if interval < 7200 { return .orange } // Less than 2 hours
        return .primary
    }

    private var progressColor: Color {
        let interval = flight.departureTime.timeIntervalSince(currentTime)
        if interval < 3600 { return .red }
        if interval < 7200 { return .orange }
        return .blue
    }
}

#Preview {
    NavigationStack {
        FlightDetailView(flight: .mock)
    }
}
