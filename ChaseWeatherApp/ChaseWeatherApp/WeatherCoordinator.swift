//
//  WeatherCoordinatior.swift
//  ChaseWeatherApp
//
//  Created by Marcelo Sotomaior on 03/09/2023.
//

import UIKit
import SwiftUI

protocol WeatherCoordinatorDelegate: AnyObject {
    // Define any delegate methods if needed
}

protocol WeatherCoordinatorRouter: AnyObject {
    func start()
    func navigateToChaseWebsite()
}
class WeatherCoordinator {
    weak var delegate: WeatherCoordinatorDelegate?
    private var navigationController: UINavigationController
    var viewToPresent = UIViewController()
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        // Create and configure the WeatherViewController
        let weatherViewModel = WeatherViewModel(weatherService: GetWeatherAPIOperation(), weatherManagerUsingDataTask: WeatherManagerUsingDataTask())
        let weatherViewController = WeatherViewController(weatherViewModel: weatherViewModel, coordinator: WeatherCoordinator(navigationController: navigationController))

//         Push or present the WeatherViewController
        navigationController.pushViewController(weatherViewController, animated: true)
    }
    

    
    // We could add many navigateToMethods. I added one as example.In a large project I would use coordinator a lot.
    func navigateToChaseWebsite(coder: NSCoder) -> UIHostingController<ChaseWebView>? {
        let weatherViewModel = WeatherViewModel(weatherService: GetWeatherAPIOperation(), weatherManagerUsingDataTask: WeatherManagerUsingDataTask())
        let chaseWebView = ChaseWebView(weatherViewModel: weatherViewModel)
        let hostingController = UIHostingController<ChaseWebView>(coder: coder, rootView: chaseWebView)
        return hostingController
    }

}


