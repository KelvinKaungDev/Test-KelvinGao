import Foundation

struct ThemeViewModel {
    static var shared = ThemeViewModel()
    
    var theme : ThemeModel {
        get{
            return ThemeModel(rawValue: UserDefaults.standard.integer(forKey: "selectedTheme")) ?? .Light
        } set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedTheme")
        }
    }
}
