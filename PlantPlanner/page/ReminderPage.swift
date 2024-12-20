import SwiftUI
import UserNotifications

struct ReminderPage: View {
    @State private var tasks: [TaskItem] = []
    @State private var preferredWateringTime: Date = Date()
    @State private var isFirstTime: Bool = UserDefaults.standard.bool(forKey: "isFirstTimeReminderPage")
    @State private var userPlants: [UserPlantData] = [] // Load plants using PlantCache
    @State private var navigateToTasks: Bool = false // Used to trigger navigation to tasks

    var body: some View {
        NavigationView {
            ZStack {
                // Gradient background for the entire page
                LinearGradient(gradient: Gradient(colors: [Color.cyan.opacity(0.25), Color.green.opacity(0.25)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    if userPlants.isEmpty {
                        noFlowersView
                    } else {
                        if isFirstTime {
                            wateringTimePromptView
                        } else {
                            taskSections
                        }
                    }
                }
                .padding()
            }
            .background(NavigationLink("", destination: taskSections, isActive: $navigateToTasks)) // Dynamically trigger navigation
        }
        .onAppear(perform: loadTasks)
    }

    private var noFlowersView: some View {
        VStack {
            Text("No flowers found. Please add a flower to start receiving watering reminders.")
                .font(.title2)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding()
        }
    }

    private var wateringTimePromptView: some View {
        VStack {
            Text("Set your preferred watering time for notifications.")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.bottom, 20)
            
            DatePicker("Preferred Watering Time", selection: $preferredWateringTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.2)))
                .shadow(radius: 5)
            
            Button("Save Time") {
                savePreferredWateringTime()
                navigateToTasks = true // Trigger navigation after saving time
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.green))
            .foregroundColor(.white)
            .fontWeight(.bold)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.4)))
        .shadow(radius: 10)
    }

    private var taskSections: some View {
        VStack(alignment: .leading, spacing: 16) {
            let groupedTasks = Dictionary(grouping: tasks) { $0.flowerName }
            
            ForEach(groupedTasks.keys.sorted(), id: \.self) { flowerName in
                VStack(alignment: .leading) {
                    Text(flowerName)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.top, 10)
                    
                    let flowerTasks = groupedTasks[flowerName] ?? []
                    ForEach(flowerTasks) { task in
                        taskRow(task: task)
                    }
                    
                    if let nextWateringDate = flowerTasks.first?.nextWateringDate {
                        let daysRemaining = daysUntilNextWatering(nextWateringDate)
                        Text("Days until next watering: \(daysRemaining)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.top, 5)
                    }
                }
                .padding(.bottom, 20)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.3)))
                .shadow(radius: 5)
            }
        }
        .padding()
    }

    private func taskRow(task: TaskItem) -> some View {
        HStack {
            Button(action: {
                toggleTaskCompletion(task)
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .font(.title)
            }
            Text(task.name)
                .strikethrough(task.isCompleted, color: .gray)
                .foregroundColor(task.isCompleted ? .gray : .primary)
                .padding(.leading, 8)
                .font(.body)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.2)))
        .shadow(radius: 5)
    }

    private func toggleTaskCompletion(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            tasks.sort { !$0.isCompleted && $1.isCompleted } // Sorting incomplete tasks at the top
        }
    }

    private func savePreferredWateringTime() {
        isFirstTime = false
        UserDefaults.standard.set(true, forKey: "isFirstTimeReminderPage")  // Save that the user has set the time
        UserDefaults.standard.set(preferredWateringTime, forKey: "preferredWateringTime")
        loadTasks()
    }

    private func loadTasks() {
        userPlants = PlantCache.shared.loadUserPlantsFromJSON()
        
        // Generate tasks for each plant
      //  generateTasksForPlants()

        // Load any existing tasks from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "tasks") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([TaskItem].self, from: data) {
                tasks = decoded
            }
        }

        if let savedTime = UserDefaults.standard.object(forKey: "preferredWateringTime") as? Date {
            preferredWateringTime = savedTime
        }
    }
/*
    private func generateTasksForPlants() {
        var newTasks: [TaskItem] = []
        
        // Iterate over each plant and create watering tasks
        for plant in userPlants {
            let task = TaskItem(
                name: "Water \(plant.name)",
                flowerName: plant.name,
                isCompleted: false,
                dueDate: calculateNextWateringDate(for: plant),
                lastWateringDate: plant.lastWateredDate, nextWateringDate: calculateNextWateringDate(for: plant) // Corrected property
            )
            newTasks.append(task)
        }
        
        // Update tasks array
        tasks = newTasks
    }

    private func calculateNextWateringDate(for plant: UserPlantData) -> Date {
        // Example: Add 7 days to the last watered date to calculate next watering date
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 7, to: plant.lastWateredDate) ?? Date() // Corrected reference to `plant.lastWateredDate`
    }
*/
    private func daysUntilNextWatering(_ date: Date) -> Int {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.day], from: currentDate, to: date)
        return components.day ?? 0
    }
}

struct TaskItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var flowerName: String
    var isCompleted: Bool
    var dueDate: Date
    var lastWateringDate: Date
    var nextWateringDate: Date
}
