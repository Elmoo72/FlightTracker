import WidgetKit
import SwiftUI
import AppIntents

struct FlightEntry: TimelineEntry {
    let date: Date
    let flight: FlightWidgetData?
}

struct FlightWidgetData: Codable {
    let flightNumber: String
    let departureCode: String
    let arrivalCode: String
    let departureTime: Date
    let status: String
    let terminal: String?
    let gate: String?
}

struct FlightProvider: TimelineProvider {
    func placeholder(in context: Context) -> FlightEntry {
        FlightEntry(date: Date(), flight: FlightWidgetData(
            flightNumber: "SU 1234",
            departureCode: "SVO",
            arrivalCode: "JFK",
            departureTime: Date().addingTimeInterval(3600 * 4),
            status: "On Time",
            terminal: "A",
            gate: "23"
        ))
    }

    func getSnapshot(in context: Context, completion: @escaping (FlightEntry) -> Void) {
        let entry = FlightEntry(date: Date(), flight: loadNearestFlight())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<FlightEntry>) -> Void) {
        let entry = FlightEntry(date: Date(), flight: loadNearestFlight())
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(900)))
        completion(timeline)
    }

    private func loadNearestFlight() -> FlightWidgetData? {
        guard let data = UserDefaults.standard.data(forKey: "savedFlights"),
              let flights = try? JSONDecoder().decode([Flight].self, from: data) else {
            return nil
        }

        let upcomingFlights = flights
            .filter { $0.departureTime > Date() }
            .sorted { $0.departureTime < $1.departureTime }

        guard let nearest = upcomingFlights.first else { return nil }

        return FlightWidgetData(
            flightNumber: nearest.flightNumber,
            departureCode: nearest.departure.code,
            arrivalCode: nearest.arrival.code,
            departureTime: nearest.departureTime,
            status: nearest.status.rawValue,
            terminal: nearest.terminal,
            gate: nearest.gate
        )
    }
}

struct FlightWidgetEntryView: View {
    var entry: FlightProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            smallWidget
        case .systemMedium:
            mediumWidget
        default:
            smallWidget
        }
    }

    private var smallWidget: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "airplane")
                    .foregroundStyle(.blue)
                Text(entry.flight?.flightNumber ?? "No Flight")
                    .font(.headline)
                    .fontWeight(.bold)
            }

            Spacer()

            if let flight = entry.flight {
                HStack {
                    Text(flight.departureCode)
                        .font(.title2)
                        .fontWeight(.bold)
                    Image(systemName: "arrow.right")
                        .font(.caption)
                    Text(flight.arrivalCode)
                        .font(.title2)
                        .fontWeight(.bold)
                }

                Text(flight.departureTime.formatted(date: .omitted, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Text("No upcoming flights")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }

    private var mediumWidget: some View {
        HStack(spacing: 16) {
            // Left: Route info
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "airplane")
                        .foregroundStyle(.blue)
                    Text(entry.flight?.flightNumber ?? "No Flight")
                        .font(.headline)
                        .fontWeight(.bold)
                }

                if let flight = entry.flight {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(flight.departureCode)
                                .font(.title)
                                .fontWeight(.bold)
                            Text(flight.departureTime.formatted(date: .omitted, time: .shortened))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Image(systemName: "arrow.right")
                            .padding(.horizontal, 8)

                        VStack(alignment: .trailing) {
                            Text(flight.arrivalCode)
                                .font(.title)
                                .fontWeight(.bold)
                        }
                    }
                }
            }

            Spacer()

            // Right: Status & Gate
            if let flight = entry.flight {
                VStack(alignment: .trailing, spacing: 8) {
                    Text(flight.status)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(statusColor(flight.status).opacity(0.15))
                        .foregroundStyle(statusColor(flight.status))
                        .clipShape(Capsule())

                    if let terminal = flight.terminal, let gate = flight.gate {
                        HStack(spacing: 12) {
                            VStack {
                                Text("T")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                Text(terminal)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            VStack {
                                Text("G")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                Text(gate)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }

    private func statusColor(_ status: String) -> Color {
        switch status {
        case "On Time", "Arrived": return .green
        case "Delayed": return .red
        case "Boarding": return .blue
        case "In Air": return .orange
        default: return .gray
        }
    }
}

struct FlightWidget: Widget {
    let kind: String = "FlightWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FlightProvider()) { entry in
            FlightWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Next Flight")
        .description("Shows your nearest upcoming flight.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    FlightWidget()
} timeline: {
    FlightEntry(date: .now, flight: FlightWidgetData(
        flightNumber: "SU 1234",
        departureCode: "SVO",
        arrivalCode: "JFK",
        departureTime: Date().addingTimeInterval(3600 * 4),
        status: "On Time",
        terminal: "A",
        gate: "23"
    ))
}

#Preview(as: .systemMedium) {
    FlightWidget()
} timeline: {
    FlightEntry(date: .now, flight: FlightWidgetData(
        flightNumber: "SU 1234",
        departureCode: "SVO",
        arrivalCode: "JFK",
        departureTime: Date().addingTimeInterval(3600 * 4),
        status: "Boarding",
        terminal: "A",
        gate: "23"
    ))
}
