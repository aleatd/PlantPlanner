import Foundation

struct UserPlantData: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var plant: Plant
    var isPotted: Bool
    var size: String
    var vaseType: String?
    var plantingDate: Date
    var lastWateredDate: Date
}
