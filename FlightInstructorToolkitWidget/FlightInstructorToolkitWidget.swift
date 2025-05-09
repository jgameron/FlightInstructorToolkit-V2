import WidgetKit
import SwiftUI
import ActivityKit

struct FlightInstructorToolkitWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FlightActivityAttributes.self) { context in
            // Lock Screen / Dynamic Island view
            VStack {
                Text("Flight Timer")
                    .font(.headline)
                Text("\(elapsedString(context.state.elapsedTime))")
                    .font(.title)
            }
            .padding()
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    Text("Flight: \(elapsedString(context.state.elapsedTime))")
                        .font(.headline)
                }
            } compactLeading: {
                Text("✈️")
            } compactTrailing: {
                Text(elapsedString(context.state.elapsedTime))
            } minimal: {
                Text("⏱️")
            }
        }
    }
    
    func elapsedString(_ time: Double) -> String {
        let hrs = Int(time) / 3600
        let mins = (Int(time) % 3600) / 60
        let secs = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hrs, mins, secs)
    }
}
