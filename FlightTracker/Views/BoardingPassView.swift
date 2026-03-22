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
                    Label("Share Boarding Pass", systemImage: "square.and.arrow.up")
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
        .navigationTitle("Boarding Pass")
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
                    Text("FROM")
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
                    Text("TO")
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
            HStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("DATE")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(flight.departureTime.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }

                Spacer()

                VStack(alignment: .center, spacing: 4) {
                    Text("BOARDING")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(flight.boardingTime?.formatted(date: .omitted, time: .shortened) ?? "--:--")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }

                Spacer()

                if let terminal = flight.terminal {
                    VStack(alignment: .center, spacing: 4) {
                        Text("TERMINAL")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text(terminal)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }

                if let gate = flight.gate {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("GATE")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text(gate)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding()
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var dashedLine: some View {
        HStack(spacing: 2) {
            ForEach(0..<50, id: \.self) { _ in
                Circle()
                    .fill(.quaternary)
                    .frame(width: 6, height: 6)
            }
        }
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

            Text("Scan at boarding gate")
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
            Text("Passenger")
                .font(.headline)

            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading) {
                    Text("Passenger Name")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text("Document last 4 digits: 1234")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var shareText: String {
        """
        🛫 Boarding Pass
        \(flight.flightNumber) | \(flight.airline)
        \(flight.departure.code) → \(flight.arrival.code)
        \(flight.departureTime.formatted(date: .abbreviated, time: .shortened))
        Terminal: \(flight.terminal ?? "-") | Gate: \(flight.gate ?? "-")
        """
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
