
import SwiftUI

struct PlantDetailPage: View {
    @Environment(\.dismiss) private var dismiss
    @State var refresh = false
    var plant: UserPlantData
    @Binding var plants: [UserPlantData]


    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color.cyan.opacity(0.25), Color.green.opacity(0.25)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: 30) {
                    // Plant image and name
                    VStack(spacing: 10) {
                        Image(plant.plant.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 3))

                        Text("\(plant.name)'s Pot")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)

                        Text(plant.plant.name)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }

                    // Status & Planted flowers
                    VStack(spacing: 20) {
                        // Status card
                        HStack {
                            VStack {
                                Image(systemName: "sun.max.fill")
                                    .font(.title)
                                    .foregroundColor(.yellow)
                                Text("Status")
                                    .font(.subheadline)
                                Text("Reasonably healthy")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            VStack {
                                Image(systemName: "leaf.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.green)
                                Text("Planted Flowers")
                                    .font(.subheadline)
                                Text("4 flowers")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)
                        )

                        // Main details
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                detailRow(icon: "sun.max", title: "Lighting", value: "Sunny")
                                Spacer()
                                detailRow(icon: "calendar", title: "Planting Date", value: formattedDate(plant.plantingDate))
                            }
                            Divider()
                            HStack {
                                detailRow(icon: "ruler.fill", title: "Height", value: "30 cm - 2 m")
                                Spacer()
                                detailRow(icon: "arrow.left.and.right", title: "Seed Distance", value: "15 cm")
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)
                        )

                        // Size and type
                        HStack {
                            detailRow(icon: "cube.fill", title: "Size", value: plant.size)
                            Spacer()
                            if let vaseType = plant.vaseType {
                                detailRow(icon: "square.and.pencil", title: "Vase Type", value: vaseType)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)
                        )
                    }

                    // Did You Know Section
                    infoCard(title: "Did You Know?", content: plant.plant.didYouKnow)

                    // Important Info Section
                    infoCard(title: "Important Info", content: plant.plant.importantInfo)
                }
                .padding()
            }
        }
        .navigationBarTitle("Sunflower Page Created", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    deletePlant()
                    update()
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }

    }

    private func deletePlant() {
        PlantCache.shared.deleteUserPlant(plant: plant)
        plants =  PlantCache.shared.loadUserPlantsFromJSON()
        dismiss()
    }

    private func update()
    {
        refresh.toggle()
    }
    // MARK: - Helper Views
    private func detailRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.system(size: 16, weight: .bold))
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.callout)
                    .foregroundColor(.primary)
            }
        }
    }

    private func infoCard(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Text(content)
                .font(.callout)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.9))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)
        )
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
