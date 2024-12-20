import SwiftUI

struct CreatePage: View {
    @Environment(\.dismiss) private var dismiss

    @State private var plantName: String = ""
    @State private var plant: Plant? = nil
    @State private var plantingDate: Date = Date()
    @State private var isPotted: Bool = true
    @State private var vaseType: String = ""
    
    @State private var isPlantTypePickerPresented = false
    @State private var isDatePickerPresented = false
    @State private var selectedVaseType: String? = nil

    @State private var rectangleLength: String = ""
    @State private var rectangleWidth: String = ""
    @State private var squareSide: String = ""
    @State private var circleRadius: String = ""
    
    private var seedDistance: Int {
        plant?.seedDistance ?? 1
    }
    
    private let vaseTypes: [String] = ["Rectangular", "Square", "Circular"]

    var onUserPlantAdded: (() -> Void)?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                header

                inputTextField("Plant Name", text: $plantName, keyboardType: .default)

                selectionRow(
                    title: "Planting Date",
                    value: formattedDate(plantingDate),
                    action: { isDatePickerPresented = true }
                )
                .sheet(isPresented: $isDatePickerPresented) {
                    datePickerView
                }

                selectionRow(
                    title: "Plant Type",
                    value: plant?.name ?? "Select",
                    action: { isPlantTypePickerPresented = true }
                )
                .sheet(isPresented: $isPlantTypePickerPresented) {
                    customPlantPickerView(
                        title: "Select Plant Type",
                        isPickerPresented: $isPlantTypePickerPresented,
                        selectedPlant: $plant
                    )
                }


                    vaseTypeButtons

                    vaseSpecificInput

                    if numberOfFlowers > 0 {
                        Text("Number of Flowers: \(numberOfFlowers)")
                            .font(.headline)
                            .padding()
                            .foregroundColor(.primary)
                            .transition(.opacity)  // Transition for smooth display
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    handleDone()
                }
            }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.cyan.opacity(0.25), Color.green.opacity(0.25)]),
                           startPoint: .top,
                           endPoint: .bottom)
        )
    }

    private var header: some View {
        HStack {
            Text("Add New Plant")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
        }
    }

    private var datePickerView: some View {
        VStack {
            Text("Select Planting Date")
                .font(.headline)
                .padding()

            Divider()

            DatePicker(
                "Planting Date",
                selection: $plantingDate,
                displayedComponents: .date
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()

            Button("Done") {
                isDatePickerPresented = false
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
        }
        .padding()
    }

    private var vaseTypeButtons: some View {
        HStack(spacing: 20) {
            ForEach(vaseTypes, id: \.self) { vase in
                Button(action: {
                    vaseType = vase
                    selectedVaseType = vase
                }) {
                    VStack {
                        Image(systemName: "cube.fill")
                            .font(.title)
                            .foregroundColor(selectedVaseType == vase ? .green : .gray)
                        Text(vase)
                            .foregroundColor(selectedVaseType == vase ? .green : .gray)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                }
            }
        }
    }

    private var vaseSpecificInput: some View {
        Group {
            if vaseType == "Rectangular" {
                VStack {
                    inputField("Length (cm)", text: $rectangleLength)
                    inputField("Width (cm)", text: $rectangleWidth)
                }
            } else if vaseType == "Square" {
                inputField("Side (cm)", text: $squareSide)
            } else if vaseType == "Circular" {
                inputField("Radius (cm)", text: $circleRadius)
            }
        }
    }

    private var numberOfFlowers: Int {
        // Calculate vase area based on type
        let area: Double
        switch vaseType {
        case "Rectangular":
            guard let length = Double(rectangleLength),
                  let width = Double(rectangleWidth) else { return 0 }
            area = length * width
        case "Square":
            guard let side = Double(squareSide) else { return 0 }
            area = side * side
        case "Circular":
            guard let radius = Double(circleRadius) else { return 0 }
            area = .pi * pow(radius, 2)
        default:
            return 0
        }

        // Calculate the number of flowers
        return Int(area / pow(Double(seedDistance), 2))
    }

    private func handleDone() {
        guard let selectedPlant = plant else {
            print("Error: No plant selected!")
            return
        }

        let newUserPlant = UserPlantData(
            name: plantName,
            plant: selectedPlant,
            isPotted: isPotted,
            size: vaseSizeDescription(),
            vaseType: vaseType,
            plantingDate: plantingDate,
            lastWateredDate: Date()
        )

        var userPlants = PlantCache.shared.loadUserPlantsFromJSON()
        userPlants.append(newUserPlant)
        PlantCache.shared.saveUserPlantData(userPlants: userPlants)

        onUserPlantAdded?()
        resetForm()

        // Dismiss the current view and return to MainPage
        dismiss()
    }

    private func vaseSizeDescription() -> String {
        switch vaseType {
        case "Rectangular":
            return "L:\(rectangleLength) x W:\(rectangleWidth) cm"
        case "Square":
            return "Side: \(squareSide) cm"
        case "Circular":
            return "Radius: \(circleRadius) cm"
        default:
            return "Unknown"
        }
    }

    private func inputField(_ placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text)
            .keyboardType(.numberPad)
            .textFieldStyle(PlainTextFieldStyle())
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
    }

    private func inputTextField(_ placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) -> some View {
        TextField(placeholder, text: text)
            .keyboardType(keyboardType)
            .textFieldStyle(PlainTextFieldStyle())
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
    }
    
    private func resetForm() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            plantName = ""
            plant = nil
            plantingDate = Date()
            isPotted = true
            vaseType = ""
            rectangleLength = ""
            rectangleWidth = ""
            squareSide = ""
            circleRadius = ""
            selectedVaseType = nil
        }
    }

    private func selectionRow(title: String, value: String, action: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
                .fontWeight(.medium)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
                .onTapGesture { action() }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func customPlantPickerView(title: String, isPickerPresented: Binding<Bool>, selectedPlant: Binding<Plant?>) -> some View {
        let plants = PlantCache.shared.loadPlantsFromJSON()

        return VStack {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .padding()

            Divider()

            ScrollView {
                ForEach(plants, id: \.name) { plant in
                    VStack {
                        Button(action: {
                            selectedPlant.wrappedValue = plant
                            isPickerPresented.wrappedValue = false
                        }) {
                            Text(plant.name)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.primary)
                        }
                        
                        Divider()
                    }
                }
            }
        }
        .padding()
    }
}

