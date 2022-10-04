import ComposableArchitecture
import Foundation
import SwiftUI

struct PomodoroState: Equatable {
    // Codes for when app becomes inactive
    var becameInactiveAt: Date = .init()
    var becameActiveAt: Date = .init()
    var secondsUntilNextPhase: TimeInterval = 0
    var passedPhasesCount: Int = 0
    var secondsToBeAdded: TimeInterval = 0

    // Configuable
    var workingTimeMinutes = 25
    var restTimeMinutes = 5

    var progressValue: Double = 0
    var progressColor: Color = .red
    var pomodoroFlag: PomodoroStatus = .finished
    var pomodoroCount: Int = 0
    var pomodoroLimit: Int = 4
    var showingDetail = false

    // Variables for Timer Formatting
    var minutes: Int = 0
    var seconds: Int = 0

    // 時間
    var secondsPassed: TimeInterval = 0
}

enum PomodoroStatus {
    case working
    case inRest
    case finished
    case interrupted
}
