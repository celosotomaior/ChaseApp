//
//  AppDelegate.swift
//  ChaseWeatherApp
//
//  Created by Marcelo Sotomaior on 03/09/2023.
//

import UIKit
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Create the main navigation controller
        navigationController = UINavigationController()

        // Create and start the WeatherCoordinator
        let weatherCoordinator = WeatherCoordinator(navigationController: navigationController!)
        weatherCoordinator.start()
        let viewModel = WeatherViewModel(weatherService: GetWeatherAPIOperation(), weatherManagerUsingDataTask: WeatherManagerUsingDataTask())
        // Create the WeatherViewController and set its coordinator
        let weatherViewController = WeatherViewController(weatherViewModel: viewModel, coordinator: weatherCoordinator)
        weatherViewController.coordinator = weatherCoordinator

        // Set the navigation controller as the root view controller
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
}

    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // The app is about to terminate (close)
        // Set the UserDefault when the user exits the app
//        let reusableUserDefaults = ReusableUserDefaults()
//        reusableUserDefaults.set(value: true, forKey: UserDefaultKeys.firstRequestInSession)
    }
}

