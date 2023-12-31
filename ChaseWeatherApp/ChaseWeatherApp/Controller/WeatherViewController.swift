import UIKit
import CoreLocation
import SwiftUI

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var maxTemp: UILabel!
    
    @IBOutlet weak var minTemp: UILabel!
    
    @IBOutlet weak var combineSwitcher: UISwitch!
    
    @IBAction func combineSwitcherPressed(_ sender: UISwitch) {
        
        // Update the user defaults value with the switcher's state
        UserDefaultKeys.combineSwitcherValue = sender.isOn
        reusableUserDefaults.set(value: UserDefaultKeys.combineSwitcherValue, forKey: UserDefaultKeys.combineSwitcherKey)
    }
    
    let weatherWithoutCombine = WeatherManagerUsingDataTask()
    
    let reusableUserDefaults = ReusableUserDefaults()
    var combineSwitcherDefault: Bool = true
    
    @IBOutlet weak var trySwiftUIButton: UIButton!
    @ObservedObject var weather: WeatherViewModel
    var coordinator: WeatherCoordinator?
    let locationManager = CLLocationManager()
    
    init(weatherViewModel: WeatherViewModel, coordinator: WeatherCoordinator) {
        self.weather = weatherViewModel
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator // Initialize 'weather' property AFTER calling super.init()
        locationManager.delegate = self
    }
    
    required init?(coder: NSCoder) {
        self.weather = WeatherViewModel(weatherService: GetWeatherAPIOperation(), weatherManagerUsingDataTask: WeatherManagerUsingDataTask())
        super.init(coder: coder)
        self.coordinator = WeatherCoordinator(navigationController: UINavigationController())
        locationManager.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        searchTextField.delegate = self
        searchTextField.autocorrectionType = .no // Disable auto-correction
        searchTextField.autocapitalizationType = .none // Disable auto-capitalization
        weather.delegate = self
        
        // Check if the app has been launched before.
        if (reusableUserDefaults.get(forKey: UserDefaultKeys.hasLaunchedBefore) == false) {
            // Set the combineSwitcherKey value to true.
            reusableUserDefaults.set(value: true, forKey: UserDefaultKeys.combineSwitcherKey)
            // Update the weather to current location in the first app launch in a fresh install
            locationManager.requestLocation()
            // Set the hasLaunchedBefore value to true.
            reusableUserDefaults.set(value: true, forKey: UserDefaultKeys.hasLaunchedBefore)
        } else {
            // Update the weather to the last city if not the first app launch in a fresh install
            let city: String? = reusableUserDefaults.get(forKey: UserDefaultKeys.city as String)
            self.weather.getWeather(for: city ?? "")
        }
    }
    
    @IBSegueAction func addSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        coordinator?.navigateToSwiftUIView(coder: coder)
    }
    
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        
        searchTextField.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            
            if UserDefaultKeys.combineSwitcherValue == true {
                self.weather.getWeather(for: city)
            } else {
                self.weather.fetchWeatherDataUsingDataTask(for: city)
            }
        }
        
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate


extension WeatherViewController: WeatherViewModelDelegate {
    func didUpdateWeather(_ weatherManager: WeatherViewModel, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.maxTemp.text = weather.tempMaxString
            self.minTemp.text = weather.tempMinString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate


extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error){
        
        
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            locationManager.stopUpdatingLocation()
            
            if UserDefaultKeys.combineSwitcherValue == true {
                self.weather.getWeather(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
                return
            } else {
                self.weather.fetchWeatherDataUsingDataTask(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
                return
            }
        }
    }
}
