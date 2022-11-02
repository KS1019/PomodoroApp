import ComposableArchitecture
import Foundation

public enum PomodoroAction: Equatable {
    case pomodoroStarted
    case pomodoroIncrementSecond
    case pomodoroFinished
    case detailViewButtonTapped
    case setIsHistoryViewShown(to: Bool)
    case setShowingDetail(to: Bool)
    case setPomodoroLimit(to: Int)
    case setWorkingTime(to: Int)
    case setRestTime(to: Int)
    case appInactivated(Date)
    case appActivated(Date)
}
