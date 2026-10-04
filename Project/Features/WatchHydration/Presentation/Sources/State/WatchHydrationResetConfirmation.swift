import Foundation

struct WatchHydrationResetConfirmation: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    var dateChanged = false
}
