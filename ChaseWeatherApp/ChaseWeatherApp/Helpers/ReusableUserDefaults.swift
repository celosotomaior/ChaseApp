import Foundation

class ReusableUserDefaults {
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func set<T>(value: T, forKey key: String) {
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }
    
    func get<T>(forKey key: String) -> T? {
        return userDefaults.object(forKey: key) as? T
    }
    
    func removeObject(forKey key: String) {
        userDefaults.removeObject(forKey: key)
        userDefaults.synchronize()
    }
}
