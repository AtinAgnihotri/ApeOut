//
//  ApeOutGameColors.swift
//  ApeOut
//
//  Created by Atin Agnihotri on 31/08/21.
//

import UIKit

extension UIColor {
    
    struct BuildingColors {
        static var firstColor: UIColor  {
            UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
        }
        static var secondColor: UIColor {
            UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
        }
        static var defaultColor: UIColor {
            UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
        }
    }
    
    struct WindowColors {
        static var lightOnColor: UIColor {
          UIColor(hue: 0.19, saturation: 0.67, brightness: 0.99, alpha: 1)
        }
        static var lightOffColor: UIColor {
          UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)
        }
    }
    
    struct BackgroundColor {
        static var backgroundColor: UIColor {
          UIColor(hue: 0.699, saturation: 0.99, brightness: 0.67, alpha: 1)
        }
    }
}
