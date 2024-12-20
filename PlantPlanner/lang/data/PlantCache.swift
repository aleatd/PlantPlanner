import Foundation

class PlantCache {
    static let shared = PlantCache()
    private init() {}

    private let plantCache = NSCache<NSString, NSArray>()
    private let userPlantCache = NSCache<NSString, NSArray>()
    private let plantCacheKey = "PlantCache"
    private let userPlantCacheKey = "UserPlantCache"
    
    func loadPlantsFromJSON() -> [Plant] {
        if let cachedPlants = plantCache.object(forKey: plantCacheKey as NSString) as? [Plant] {
            return cachedPlants
        }
        let plants = loadUpdatedPlants()
        plantCache.setObject(plants as NSArray, forKey: plantCacheKey as NSString)
        
        print("Loading plants")
        return plants
    }
    
    func updatePlantCache(with plants: [Plant]) {
        plantCache.setObject(plants as NSArray, forKey: plantCacheKey as NSString)
    }
    
    func loadUserPlantsFromJSON() -> [UserPlantData] {
        if let cachedUserPlants = userPlantCache.object(forKey: userPlantCacheKey as NSString) as? [UserPlantData] {
            return cachedUserPlants
        }
        
        let userPlants = loadUserPlantData()
        userPlantCache.setObject(userPlants as NSArray, forKey: userPlantCacheKey as NSString)
        
        print(userPlants)
        return userPlants
    }
    
    func updateUserPlantCache(with userPlants: [UserPlantData]) {
        userPlantCache.setObject(userPlants as NSArray, forKey: userPlantCacheKey as NSString)
    }

    func clearAllCache() {
        plantCache.removeAllObjects()
        userPlantCache.removeAllObjects()
    }
        
    private func loadUpdatedPlants() -> [Plant] {
        let decoder = JSONDecoder()

        guard let url = Bundle.main.url(forResource: "Data", withExtension: "json") else {
            print("Data.json non trovato nel bundle")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let plantDictionary = try decoder.decode([String: Plant].self, from: data)

            return Array(plantDictionary.values)
        } catch {
            print("Errore nella decodifica dei dati delle piante: \(error)")
            return []
        }
    }

    
    private func loadUserPlantData() -> [UserPlantData] {
        let decoder = JSONDecoder()
        guard let url = getDocumentsDirectory()?.appendingPathComponent("UserPlants.json"),
              FileManager.default.fileExists(atPath: url.path) else {
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            return try decoder.decode([UserPlantData].self, from: data)
        } catch {
            print("Error decoding user plant data: \(error)")
            return []
        }
    }
    
    func getPlant(byName name: String) -> Plant? {
        let plants = loadPlantsFromJSON()
        return plants.first { $0.scientificName.caseInsensitiveCompare(name) == .orderedSame }
    }
    
    func saveUserPlantData(userPlants: [UserPlantData]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(userPlants)
            guard let url = getDocumentsDirectory()?.appendingPathComponent("UserPlants.json") else {
                print("Unable to find documents directory.")
                return
            }
            
            try data.write(to: url)
            print("User plant data saved successfully.")
            
            updateUserPlantCache(with: userPlants)
        } catch {
            print("Error saving user plant data: \(error)")
        }
    }
    
    // Method to delete a specific plant from the user plants list
    func deleteUserPlant(plant: UserPlantData) {
        var userPlants = loadUserPlantsFromJSON()
        print(plant)
        // Find the index of the plant to delete
        if let index = userPlants.firstIndex(where: { $0.id == plant.id }) {
            userPlants.remove(at: index)
            
            // Save the updated list back to the JSON file
            saveUserPlantData(userPlants: userPlants)
            
            // Update the cache
            updateUserPlantCache(with: userPlants)
            
            print("Plant deleted successfully.")
        } else {
            print("Plant not found.")
        }
    }
    
    // Helper function to get the documents directory
    private func getDocumentsDirectory() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first
    }
}

