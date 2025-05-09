import ActivityKit

struct FlightActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var elapsedTime: Double
    }
    
    var dummy: String = ""
}
