import SwiftUI
import CoreImage.CIFilterBuiltins

struct BoardingPassView: View {
    let flight: Flight

    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Boarding pass card
                boardingPassCard

                // QR Code
                qrCodeSection

                // Passenger info placeholder
                passengerInfoSection

                // Share button
                ShareLink(item: shareText) {
                    Label("boarding_pass_share", systemImage: "square.and.arrow.up")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        }
        .navigationTitle("boarding_pass_title")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var boardingPassCard: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text(flight.airline)
                        .font(.headline)
                    Text(flight.flightNumber)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                Spacer()
                Image(systemName: "airplane")
                    .font(.largeTitle)
                    .foregroundStyle(.blue)
            }
            .padding()
            .background(Color.blue.opacity(0.1))

            // Route
            HStack {
                VStack(alignment: .leading) {
                    Text("boarding_pass_from")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(flight.departure.code)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(flight.departure.city)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(spacing: 4) {
                    Image(systemName: "airplane")
                        .font(.title3)
                    Rectangle()
                        .fill(.quaternary)
                        .frame(width: 40, height: 1)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("boarding_pass_to")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(flight.arrival.code)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(flight.arrival.city)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()

            // Tear line
            dashedLine

            // Details
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("boarding_pass_date")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(flight.departureTime.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .center, spacing: 4) {
                    Text("boarding_pass_boarding")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(flight.boardingTime?.formatted(date: .omitted, time: .shortened) ?? "--:--")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity, alignment: .center)

                if let terminal = flight.terminal {
                    VStack(alignment: .center, spacing: 4) {
                        Text("boarding_pass_terminal")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text(terminal)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }

                if let gate = flight.gate {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("boarding_pass_gate")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text(gate)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .padding()
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var dashedLine: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0.5))
                path.addLine(to: CGPoint(x: geometry.size.width, y: 0.5))
            }
            .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
            .foregroundStyle(.quaternary)
        }
        .frame(height: 1.5)
        .padding(.horizontal)
    }

    private var qrCodeSection: some View {
        VStack(spacing: 12) {
            if let qrImage = generateQRCode(from: flight.qrCodeData ?? flight.flightNumber) {
                Image(uiImage: qrImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Text("boarding_pass_scan_hint")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var passengerInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("boarding_pass_passenger")
                .font(.headline)

            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading) {
                    Text(flight.passengerName ?? String(localized: "boarding_pass_not_specified"))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(String(format: String(localized: "boarding_pass_doc_last_four"), flight.documentLastFour ?? "----"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if let seat = flight.seatNumber {
                Divider()
                HStack {
                    Text("boarding_pass_seat")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(seat)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var shareText: String {
        var text = """
        🛫 Boarding Pass
        \(flight.flightNumber) | \(flight.airline)
        \(flight.departure.code) → \(flight.arrival.code)
        \(flight.departureTime.formatted(date: .abbreviated, time: .shortened))
        Terminal: \(flight.terminal ?? "-") | Gate: \(flight.gate ?? "-")
        """
        if let name = flight.passengerName {
            text += "\nPassenger: \(name)"
        }
        if let seat = flight.seatNumber {
            text += " | Seat: \(seat)"
        }
        return text
    }

    private func generateQRCode(from string: String) -> UIImage? {
        filter.message = Data(string.utf8)
        filter.correctionLevel = "M"

        guard let outputImage = filter.outputImage else { return nil }

        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = outputImage.transformed(by: transform)

        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }

        return UIImage(cgImage: cgImage)
    }
}

#Preview {
    NavigationStack {
        BoardingPassView(flight: .mock)
    }
}
