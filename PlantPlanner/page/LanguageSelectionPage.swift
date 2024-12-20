import SwiftUI

struct LanguageSelectionPage: View {
    @Binding var selectedLanguage: String
    @Environment(\.dismiss) private var dismiss

    private let languages = ["English", "Italian", "Spanish", "French"]
    private let languageCodes = ["en", "it", "es", "fr"]
    private let darkBrown = Color(red: 85/255, green: 61/255, blue: 53/255)

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                VStack {
                    header
                    languageList
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
            Text("Select Language")
                .font(.custom("Helvetica", size: 30))
                .fontWeight(.bold)
                .foregroundColor(darkBrown)
            Spacer()
        }
        .padding(.top, 20)
    }

    private var languageList: some View {
        VStack(spacing: 15) {
            ForEach(0..<languages.count, id: \.self) { index in
                Button(action: {
                    selectedLanguage = languageCodes[index]
                    updateAppLanguage(to: languageCodes[index])  // Cambia la lingua quando selezionata
                    dismiss()  // Torna indietro dopo aver selezionato la lingua
                }) {
                    HStack {
                        Text(languages[index])
                            .font(.custom("Helvetica", size: 18))
                            .foregroundColor(darkBrown)
                        Spacer()
                        if selectedLanguage == languageCodes[index] {
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

    private func updateAppLanguage(to languageCode: String) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        Bundle.setLanguage(languageCode)
    }
}

