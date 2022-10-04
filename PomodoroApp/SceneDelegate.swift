import ComposableArchitecture
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let store = Store(
        initialState: PomodoroState(),
        reducer: pomodoroReducer,
        environment: PomodoroEnvironment(
            notification: NotificationHandler.shared, mainQueue: .main
        )
    )
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        let mainView = ContentView(store: store)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: mainView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_: UIScene) {
        NotificationHandler.shared.cancelAllPendingNotifications()
    }

    func sceneDidBecomeActive(_: UIScene) {
        ViewStore(store).send(.appActivated(Date()))
    }

    func sceneWillResignActive(_: UIScene) {
        ViewStore(store).send(.appInactivated(Date()))
    }

    func sceneWillEnterForeground(_: UIScene) {}

    func sceneDidEnterBackground(_: UIScene) {}
}
