//
//  GradientView+Predefined.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 18.09.2022.
//

import UIKit

extension GradientView {
    
    enum PredefinedList: CaseIterable {
        case mauve, royal, dusk
        case deepSeaSpace, grapefruitSunset
        case brightVault, politics, tranquil
        case forest, timber
        
        var startColor: UIColor {
            switch self {
            case .mauve:
                return UIColor(hex: "#42275a")
            case .royal:
                return UIColor(hex: "#141E30")
            case .dusk:
                return UIColor(hex: "#2C3E50")
            case .deepSeaSpace:
                return UIColor(hex: "#2C3E50")
            case .grapefruitSunset:
                return UIColor(hex: "#e96443")
            case .brightVault:
                return UIColor(hex: "#00d2ff")
            case .politics:
                return UIColor(hex: "#2196f3")
            case .tranquil:
                return UIColor(hex: "#EECDA3")
            case .forest:
                return UIColor(hex: "#5A3F37")
            case .timber:
                return UIColor(hex: "#fc00ff")
            }
        }
        
        var endColor: UIColor {
            switch self {
            case .mauve:
                return UIColor(hex: "#734b6d")
            case .royal:
                return UIColor(hex: "#243B55")
            case .dusk:
                return UIColor(hex: "#FD746C")
            case .deepSeaSpace:
                return UIColor(hex: "#4CA1AF")
            case .grapefruitSunset:
                return UIColor(hex: "#904e95")
            case .brightVault:
                return UIColor(hex: "#928DAB")
            case .politics:
                return UIColor(hex: "#f44336")
            case .tranquil:
                return UIColor(hex: "#EF629F")
            case .forest:
                return UIColor(hex: "#2C7744")
            case .timber:
                return UIColor(hex: "#00dbde")
            }
        }
        
        func createView() -> GradientView {
            let gradientView = GradientView()
            
            gradientView.layer.masksToBounds = true
            gradientView.direction = .horizontal
            gradientView.startColor = startColor
            gradientView.endColor = endColor
            
            return gradientView
        }
    }
}

fileprivate extension UIColor {
    
    convenience init(hex: String) {

        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        if (cString.count) != 6 {
            self.init(red: 255, green: 255, blue: 255, alpha: 1)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: 1.0)
    }
}
