import Foundation

struct Plant: Codable {
    var name: String
    var scientificName: String
    var imageName: String
    var lighting: String
    var water: String
    var potSizeWidth: Int
    var potSizeLength: Int
    var seedDistance: Int
    var heightMin: Int
    var heightMax: Int
    var plantingPeriod: String
    var bloomingPeriod: String
    var soilType: String
    var minTemperature: Int
    var maxTemperature: Int
    var squareSideLenght: Int
    var baseLength: Int
    var heightLength: Int
    var plantingDate: String
    var selectedVaseType: String
    var room: String
    var didYouKnow: String
    var importantInfo: String
}

func getDocumentsDirectory() -> URL? {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
}
