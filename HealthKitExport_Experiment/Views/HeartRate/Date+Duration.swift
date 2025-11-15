import Foundation

extension Date {
    func durationString(to other: Date, allowedUnits: NSCalendar.Unit = [.day, .hour, .minute, .second], maxUnits: Int = 2) -> String {
        let interval = abs(other.timeIntervalSince(self))
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = allowedUnits
        formatter.maximumUnitCount = maxUnits
        formatter.zeroFormattingBehavior = .dropAll
        return formatter.string(from: interval) ?? ""
    }
}
