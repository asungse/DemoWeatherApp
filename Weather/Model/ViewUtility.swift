//
//  ViewUtility.swift
//  Weather
//
//  Created by Alvin on 12/10/2021.
//

import SwiftUI

struct ViewUtility {
    static let shared = ViewUtility()
    
    let locationIconName = "location.fill"
    let themeLinearGradient = ViewUtility.getThemeLinearGradientByLocaleRegionCode()
    
    private static func getThemeLinearGradientByLocaleRegionCode() -> LinearGradient {
        var colors: [Color]!
        switch Locale.current.regionCode?.uppercased() {
        case "US":
            colors = [.cyan, .indigo]
        case "HK":
            colors = [.orange, .mint]
        case "AU":
            colors = [.brown, .yellow]
        case "CA":
            colors = [.green, .yellow]
        default:
            colors = [.yellow, .cyan]
        }
        return LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .trailing)
    }
}
