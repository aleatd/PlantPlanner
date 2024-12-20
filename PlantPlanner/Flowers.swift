import Foundation

class Coordinate: Codable {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double = 0.0, longitude: Double = 0.0) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // Inizializzatore per la deserializzazione
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
    }
    
    private enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
}

class Mesure: Coordinate {
    var dimension: Double
    var unit: String
    
    init(latitude: Double = 0.0, longitude: Double = 0.0, dimension: Double = 0.0, unit: String = "M") {
        self.dimension = dimension
        self.unit = unit
        super.init(latitude: latitude, longitude: longitude)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dimension = try container.decode(Double.self, forKey: .dimension)
        self.unit = try container.decode(String.self, forKey: .unit)
        
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case dimension
        case unit
    }
}

class Flower: Mesure {
    enum Flowers: String, CaseIterable, Codable {
        case carnation = "Garofano"
        case chrysanthemum = "Crisantemo"
        case gerbera = "Gerbera"
        case greenTrick = "Green Trick"
        case peonie = "Peonia"
        case rose = "Rosa"
        case statice = "Statice"
        case sunflower = "Girasole"
        case tulip = "Tulipano"
        case wallflower = "Violaciocca"
        case defaultValue = ""
    }
    
    var id: Int
    var greenHouseName: String
    var size: Mesure
    var type: Flowers
    
    init(id: Int = 0, greenHouseName: String = "", size: Mesure = Mesure(), type: Flowers = .defaultValue) {
        self.id = id
        self.greenHouseName = greenHouseName
        self.size = size
        self.type = type
        super.init(latitude: size.latitude, longitude: size.longitude, dimension: size.dimension, unit: size.unit)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.greenHouseName = try container.decode(String.self, forKey: .greenHouseName)
        
        self.size = try container.decode(Mesure.self, forKey: .size)
        
        self.type = try container.decode(Flowers.self, forKey: .type)
        
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case greenHouseName
        case size
        case type
    }
}

class Terrain: Flower {
    
    override init(id: Int = 0, greenHouseName: String = "", size: Mesure = Mesure(), type: Flowers = .defaultValue) {
        super.init(id: id, greenHouseName: greenHouseName, size: size, type: type)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    func getGreenHouseName() -> String {
        return self.greenHouseName
    }
    
    func setGreenHouseName(_ greenHouseName: String) {
        self.greenHouseName = greenHouseName
    }
    
    func getSize() -> Mesure {
        return self.size
    }
    
    func setSize(_ size: Mesure) {
        self.size = size
    }
    
    func getType() -> Flowers {
        return self.type
    }
    
    func setType(_ type: Flowers) {
        self.type = type
    }
}

