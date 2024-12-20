import SwiftUI

struct SearchPage: View {
    @State private var searchQuery = ""
    @State private var plants = ["plant"]
    @State private var filteredPlants = [String]()

    private let darkBrown = Color(red: 85/255, green: 61/255, blue: 53/255)
    private let backgroundColor = Color.white.opacity(0.95)

    var body: some View {
        ZStack {
            VStack {
                searchBar
                plantList
            }
            .padding()
        }
        .onChange(of: searchQuery) { query in
            filterPlants(query: query)
        }
    }

    private var searchBar: some View {
        TextField("Search for plants", text: $searchQuery)
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 0)
            .padding(.bottom, 20)
            .font(.title3)
            .foregroundColor(darkBrown)
            .textInputAutocapitalization(.none)
            .disableAutocorrection(true)
            .padding(.horizontal)
    }

    private var plantList: some View {
        Group {
            if filteredPlants.isEmpty {}
            else {
                List(filteredPlants, id: \.self) { plant in
                    Text(plant)
                        .font(.custom("Helvetica", size: 18))
                        .foregroundColor(darkBrown)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(darkBrown, lineWidth: 1)
                        )
                        .padding(.horizontal)
                }
                .listStyle(PlainListStyle())  // Ottimizza la lista senza bordi aggiuntivi
            }
        }
    }

    private func filterPlants(query: String) {
        if query.isEmpty {
            filteredPlants = plants
        } else {
            filteredPlants = plants.filter { $0.lowercased().contains(query.lowercased()) }
        }
    }
}
