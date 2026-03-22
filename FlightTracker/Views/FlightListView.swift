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
                    FlightCardView(flight: flight)
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
            .onDelete(perform: viewModel.deleteFlights)
        }
        .listStyle(.plain)
        .refreshable {
            // Refresh from API
        }
    }
}

#Preview {
    FlightListView()
}
