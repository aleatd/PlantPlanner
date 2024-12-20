import SwiftUI

struct TemperatureUnitSelectionPage: View {
    @Binding var selectedTemperatureUnit: String
    @Environment(\.presentationMode) var presentationMode

    private let units = ["Celsius", "Fahrenheit"]
    private let darkBrown = Color(red: 85/255, green: 61/255, blue: 53/255)

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                VStack {
                    header
                    unitList
                    Spacer()
                }
                .padding(.horizontal)
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.cyan.opacity(0.35), Color.green.opacity(0.35)]),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }

    private var header: some View {
        HStack {
            Text("Select Temperature Unit")
                .font(.custom("Helvetica", size: 30))
                .fontWeight(.bold)
                .foregroundColor(darkBrown)
            Spacer()
        }
        .padding(.top, 20)
    }

    private var unitList: some View {
        VStack(spacing: 15) {
            ForEach(units, id: \.self) { unit in
                Button(action: {
                    selectedTemperatureUnit = unit
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text(unit)
                            .font(.custom("Helvetica", size: 18))
                            .foregroundColor(darkBrown)
                        Spacer()
                        if selectedTemperatureUnit == unit {
                            Image(systemName: "checkmark")
                                .foregroundColor(darkBrown)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 0)
                }
            }
        }
    }
}

