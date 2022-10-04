import ComposableArchitecture
import Foundation

struct PomodoroEnvironment {
    let notification: NotificationHandler
    var mainQueue: AnySchedulerOf<DispatchQueue>
}
