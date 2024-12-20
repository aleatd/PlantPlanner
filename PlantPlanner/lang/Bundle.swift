import Foundation

extension Bundle {
    private static var currentBundle: Bundle = .main
    
    // Method to set the language for the app dynamically
    static func setLanguage(_ languageCode: String) {
        // Get the path for the .lproj folder
        guard let languageBundlePath = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let languageBundle = Bundle(path: languageBundlePath) else {
            return
        }

        // Set the current bundle to the new language bundle
        object_setClass(Bundle.main, CustomBundle.self)
        currentBundle = languageBundle
    }
    
    // Method to fetch localized strings from the current bundle
    static func localizedString(forKey key: String, comment: String) -> String {
        return currentBundle.localizedString(forKey: key, value: nil, table: nil)
    }
}

private class CustomBundle: Bundle {
    // Override preferredLocalizations to ensure that we return the correct localization
    override class func preferredLocalizations(from localizations: [String]) -> [String] {
        // Return the first language from the list based on our current language setting
        return [Bundle.preferredLocalizations(from: localizations).first ?? "en"]
    }
}
