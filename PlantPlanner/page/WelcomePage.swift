import SwiftUI

struct WelcomePage: View {
    @State private var currentPage = 0
    @State private var showDefaultPage = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            backgroundGradient
            contentView
        }
        .onAppear {
            // Check if the "isPresented" flag is set in UserDefaults
            if UserDefaults.standard.bool(forKey: "isPresented") {
                showDefaultPage = true
            }
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.cyan.opacity(0.35), Color.green.opacity(0.35)]),
            startPoint: .top,
            endPoint: .bottom
        ).edgesIgnoringSafeArea(.all)
    }
    
    private var contentView: some View {
        VStack {
            Spacer()
            
            tabView
            
            Spacer(minLength: 20)
            
            PageControl(currentPage: $currentPage)
                .padding(.top, -35)
    
            Spacer()
            
            getStartedButton
            
            Spacer(minLength: 25)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .fullScreenCover(isPresented: $showDefaultPage) {
            MainPage()
        }
    }
    
    private var tabView: some View {
        TabView(selection: $currentPage) {
            WelcomePageView(
                imageName: "welcome.first",
                title: NSLocalizedString("WelcomeTitle", comment: "Welcome title"),
                description: NSLocalizedString("WelcomeDescription", comment: "Welcome description"),
                tag: 0
            )
            
            WelcomePageView(
                imageName: "welcome.second",
                title: NSLocalizedString("GreenThumbSecrets", comment: "Green thumb secrets title"),
                description: NSLocalizedString("GreenThumbDescription", comment: "Green thumb description"),
                tag: 1
            )
            
            WelcomePageView(
                imageName: "welcome.third",
                title: NSLocalizedString("CareForYourPlants", comment: "Care for your plants title"),
                description: NSLocalizedString("CareDescription", comment: "Care for your plants description"),
                tag: 2
            )
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
    
    private var getStartedButton: some View {
        Button(action: {
            // Save to UserDefaults when "Get Started" is pressed
            UserDefaults.standard.set(true, forKey: "isPresented")
            showDefaultPage = true
        }) {
            Text(NSLocalizedString("GetStarted", comment: "Get started button"))
                .font(.custom("Helvetica", size: 18))
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
        }
        .padding(.horizontal, 20)
    }
}

struct WelcomePageView: View {
    let imageName: String
    let title: String
    let description: String
    let tag: Int
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .padding(.bottom, 8)
        
            Text(title)
                .font(.custom("Helvetica", size: 18))
                .fontWeight(.medium)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 12)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Divider()
                .frame(width: 100, height: 2)
                .background(colorScheme == .dark ? Color.white : Color.black)
                .padding(.top, 10)
            
            Text(description)
                .font(.custom("Helvetica", size: 14))
                .fontWeight(.regular)
                .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.8) : Color.black.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .padding(.top, 10)
        }
        .tag(tag)
    }
}

struct PageControl: View {
    @Binding var currentPage: Int
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(index == currentPage ? (colorScheme == .dark ? Color.white : Color.black) : Color.gray.opacity(0.5))
                    .frame(width: 10, height: 10)
                    .scaleEffect(index == currentPage ? 1.3 : 1.0)
            }
        }
        .padding(.top, 10)
    }
}

#Preview {
    WelcomePage()
}

