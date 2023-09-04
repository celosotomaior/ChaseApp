import UIKit
import SwiftUI

protocol WeatherCoordinatorDelegate: AnyObject {
    // Define any delegate methods if needed
}

protocol WeatherCoordinatorRouter: AnyObject {
    func start()
    func navigateToSwiftUIView()
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
        
        // Push or present the WeatherViewController
        navigationController.pushViewController(weatherViewController, animated: true)
    }
    
    // We could add many navigateToMethods. I added one as example.In a large project I would use coordinator a lot.
    func navigateToSwiftUIView(coder: NSCoder) -> UIHostingController<WeatherSwiftUIView>? {
        let weatherViewModel = WeatherViewModel(weatherService: GetWeatherAPIOperation(), weatherManagerUsingDataTask: WeatherManagerUsingDataTask())
        let weatherSwiftUIView = WeatherSwiftUIView(weatherViewModel: weatherViewModel)
        let hostingController = UIHostingController<WeatherSwiftUIView>(coder: coder, rootView: weatherSwiftUIView)
        return hostingController
    }
}
