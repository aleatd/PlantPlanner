import SwiftUI

@main
struct PlantPlanner: App {
    @State private var isPresented: Bool = UserDefaults.standard.bool(forKey: "isPresented")

    
    var body: some Scene {
        WindowGroup {
            if isPresented {
                MainPage()
            } else {
                WelcomePage()
            }
        }
    }
}
