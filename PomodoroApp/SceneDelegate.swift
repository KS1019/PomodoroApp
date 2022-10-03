//
//  SceneDelegate.swift
//  PomodoroApp
//
//  Created by Kotaro Suto on 2020/07/26.
//  Copyright © 2020 Kotaro Suto. All rights reserved.
//

import UIKit
import SwiftUI
import ComposableArchitecture

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let store =  Store(
        initialState: PomodoroState(),
        reducer: pomodoroReducer,
        environment: PomodoroEnvironment(
            notification: NotificationHandler.shared, mainQueue: .main))
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let mainView = ContentView(store: store)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: mainView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        NotificationHandler.shared.cancelAllPendingNotifications()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        ViewStore(store).send(.appActivated(Date()))
    }

    func sceneWillResignActive(_ scene: UIScene) {
        ViewStore(store).send(.appInactivated(Date()))
    }

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

