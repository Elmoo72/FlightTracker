import SwiftUI

struct FlightListView: View {
    @StateObject private var viewModel = FlightViewModel()
    @State private var showingAddFlight = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.flights.isEmpty {
                    emptyState
                } else {
                    flightList
                }
            }
            .navigationTitle("My Flights")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddFlight = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddFlight) {
                AddFlightView { flight in
                    viewModel.addFlight(flight)
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.ultraThinMaterial)
                }
            }
            .alert("Ошибка", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Flights", systemImage: "airplane")
        } description: {
            Text("Add your upcoming flights to track them")
        } actions: {
            Button("Add Flight") {
                showingAddFlight = true
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var flightList: some View {
        List {
            ForEach(viewModel.flights) { flight in
                NavigationLink(destination: FlightDetailView(flight: flight)) {
                    FlightCardView(
                        flight: flight,
                        timeUntilDeparture: viewModel.timeUntilDeparture(flight),
                        timeUntilBoarding: viewModel.timeUntilBoarding(flight),
                        isToday: viewModel.isFlightToday(flight)
                    )
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
            .onDelete(perform: viewModel.deleteFlights)
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.refreshFlights()
        }
    }
}

#Preview {
    FlightListView()
}
