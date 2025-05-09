import SwiftUI
import ActivityKit

struct ContentView: View {
    @State private var timerRunning = false
    @State private var startTime: Date?
    @State private var elapsed: TimeInterval = 0
    @State private var studentLandings = 0
    @State private var instructorLandings = 0
    @State private var hobbsStart = ""
    @State private var hobbsEnd = ""
    @State private var tachStart = ""
    @State private var tachEnd = ""
    @State private var elapsedStart = ""
    @State private var elapsedEnd = ""
    
    @State private var activity: Activity<FlightActivityAttributes>?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Flight Instructor Toolkit")
                    .font(.largeTitle)
                
                // Flight Timer
                GroupBox(label: Text("Flight Timer")) {
                    Text(elapsedTimeString())
                        .font(.title)
                    HStack {
                        Button("Start Timer") { startTimer() }
                        Button("Stop Timer") { stopTimer() }
                        Button("Reset") { resetTimer() }
                            .foregroundColor(.red)
                    }
                }
                
                // Landings
                GroupBox(label: Text("Landings")) {
                    HStack {
                        VStack {
                            Text("Student: \(studentLandings)")
                            HStack {
                                Button("+1") { studentLandings += 1 }
                                Button("-1") { if studentLandings > 0 { studentLandings -= 1 } }
                            }
                        }
                        VStack {
                            Text("Instructor: \(instructorLandings)")
                            HStack {
                                Button("+1") { instructorLandings += 1 }
                                Button("-1") { if instructorLandings > 0 { instructorLandings -= 1 } }
                            }
                        }
                    }
                }
                
                // Hobbs
                GroupBox(label: Text("Hobbs Time")) {
                    TextField("Start", text: $hobbsStart)
                        .keyboardType(.decimalPad)
                    TextField("End", text: $hobbsEnd)
                        .keyboardType(.decimalPad)
                    Button("Calculate") {
                        calculateHobbs()
                    }
                }
                
                // Tach
                GroupBox(label: Text("Tach Time")) {
                    TextField("Start", text: $tachStart)
                        .keyboardType(.decimalPad)
                    TextField("End", text: $tachEnd)
                        .keyboardType(.decimalPad)
                    Button("Calculate") {
                        calculateTach()
                    }
                }
                
                // Elapsed
                GroupBox(label: Text("Elapsed Time")) {
                    TextField("Start (HH:MM)", text: $elapsedStart)
                    TextField("End (HH:MM)", text: $elapsedEnd)
                    Button("Calculate") {
                        calculateElapsed()
                    }
                }
            }
            .padding()
        }
    }
    
    func elapsedTimeString() -> String {
        let time = timerRunning ? Date().timeIntervalSince(startTime ?? Date()) : elapsed
        let hrs = Int(time) / 3600
        let mins = (Int(time) % 3600) / 60
        let secs = Int(time) % 60
        let decimal = floor((time / 3600) * 100) / 100
        return String(format: "%.2f hrs | %02d:%02d:%02d", decimal, hrs, mins, secs)
    }
    
    func startTimer() {
        startTime = Date()
        timerRunning = true
        activity = try? Activity<FlightActivityAttributes>.request(
            attributes: FlightActivityAttributes(),
            contentState: FlightActivityAttributes.ContentState(elapsedTime: 0),
            pushType: nil)
    }
    
    func stopTimer() {
        if let start = startTime {
            elapsed += Date().timeIntervalSince(start)
        }
        timerRunning = false
        activity?.end(dismissalPolicy: .immediate)
    }
    
    func resetTimer() {
        startTime = nil
        elapsed = 0
        timerRunning = false
        activity?.end(dismissalPolicy: .immediate)
    }
    
    func calculateHobbs() {
        if let s = Double(hobbsStart), let e = Double(hobbsEnd) {
            let res = floor((e - s) * 100) / 100
            print("Hobbs: \(res)")
        }
    }
    
    func calculateTach() {
        if let s = Double(tachStart), let e = Double(tachEnd) {
            let res = floor((e - s) * 100) / 100
            print("Tach: \(res)")
        }
    }
    
    func calculateElapsed() {
        let startParts = elapsedStart.split(separator: ":").compactMap { Int($0) }
        let endParts = elapsedEnd.split(separator: ":").compactMap { Int($0) }
        guard startParts.count == 2, endParts.count == 2 else { return }
        var startMins = startParts[0] * 60 + startParts[1]
        var endMins = endParts[0] * 60 + endParts[1]
        if endMins < startMins { endMins += 1440 }
        let hours = floor((Double(endMins - startMins) / 60) * 100) / 100
        print("Elapsed: \(hours)")
    }
}
