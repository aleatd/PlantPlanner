import SwiftUI

struct SettingsPage: View {
    @AppStorage("selectedLanguage") private var selectedLanguage = Locale.preferredLanguages.first ?? "en"
    @AppStorage("temperatureUnit") private var temperatureUnit = "Celsius"
    @AppStorage("lengthUnit") private var lengthUnit = "Meters"
    
    @State private var notificationsEnabled = true

    var body: some View {
        NavigationStack {
            ZStack {
                // Gradient background for the page
                LinearGradient(gradient: Gradient(colors: [Color.cyan.opacity(0.25), Color.green.opacity(0.25)]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    // Title similar to MainPage
                    Text("Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 20)

                    Form {
                        Section {
                            languagePicker
                                .padding(.vertical, 8)
                            notificationToggle
                                .padding(.vertical, 8)
                            temperatureUnitPicker
                                .padding(.vertical, 8)
                            lengthUnitPicker
                                .padding(.vertical, 8)
                        }
                        .listRowBackground(Color.clear) // Transparent background for the form rows
                    }
                    .scrollContentBackground(.hidden) // Transparent background for the entire form
                    .padding(.top, -20) // Adjust form to align properly below the title
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true) // Hide default navigation bar
        .onAppear {
            // Forza il recupero e l'aggiornamento del valore da AppStorage
            selectedLanguage = selectedLanguage // Aggiungi questa riga se necessario per forzare la sincronizzazione
            temperatureUnit = temperatureUnit
            lengthUnit = lengthUnit
        }
        .onChange(of: selectedLanguage) { newValue in
            updateAppLanguage(to: newValue) // Cambia la lingua quando selezionata
        }
    }

    private var languagePicker: some View {
        HStack {
            Text("Language")
                .font(.body)
                .foregroundColor(.primary)
            Spacer()
            Picker("", selection: $selectedLanguage) {
                Text("English").tag("en")
                Text("Italian").tag("it")
                Text("Spanish").tag("es")
                Text("French").tag("fr")
            }
            .pickerStyle(MenuPickerStyle())
            .accentColor(.blue)
        }.onAppear {
            // Mostra la lingua attuale nella UI (logicamente già gestito tramite @AppStorage)
            print("Lingua selezionata: \(selectedLanguage)")
        }
    }

    private var notificationToggle: some View {
        Toggle(isOn: $notificationsEnabled) {
            Text("Notifications")
                .font(.body)
                .foregroundColor(.primary)
        }
        .toggleStyle(SwitchToggleStyle(tint: .blue))
    }

    private var temperatureUnitPicker: some View {
        HStack {
            Text("Temperature Unit")
                .font(.body)
                .foregroundColor(.primary)
            Spacer()
            Picker("", selection: $temperatureUnit) {
                Text("Celsius").tag("Celsius")
                Text("Fahrenheit").tag("Fahrenheit")
            }
            .pickerStyle(MenuPickerStyle())
            .accentColor(.blue)
        }
    }

    private var lengthUnitPicker: some View {
        HStack {
            Text("Length Unit")
                .font(.body)
                .foregroundColor(.primary)
            Spacer()
            Picker("", selection: $lengthUnit) {
                Text("Meters").tag("Meters")
                Text("Feet").tag("Feet")
                Text("Yards").tag("Yards")
            }
            .pickerStyle(MenuPickerStyle())
            .accentColor(.blue)
        }
    }

    private func updateAppLanguage(to languageCode: String) {
        // Modifica AppleLanguages in UserDefaults per cambiare la lingua
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        
        // Aggiorna il bundle per caricare i nuovi testi nella lingua selezionata
        Bundle.setLanguage(languageCode)
        
        // Forza la ricarica dell'interfaccia utente
        NotificationCenter.default.post(name: .languageChanged, object: nil)
    }
}

extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}

#Preview {
    SettingsPage()
}
