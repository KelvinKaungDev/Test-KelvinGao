import UIKit
import Foundation

enum ThemeModel : Int {
    case Light
    case Dark
    
    func getUserInterfaceStyle() -> UIUserInterfaceStyle {
        switch self {
            case .Light :
                return .light
            case .Dark :
                return .dark
        }
    }
}
