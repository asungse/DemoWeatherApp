//
//  ApiResponse.swift
//  Weather
//
//  Created by Alvin on 10/10/2021.
//

import Foundation

struct ApiResponse: Codable {
    // Parameters structured with reference to API response - https://openweathermap.org/current#current_JSON
    struct Coord: Codable {
        let lon: Double?
        let lat: Double?
    }

    struct Weather: Codable {
        let id: Int?
        let main: String?
        let description: String?
        let icon: String?
    }

    struct Main: Codable {
        let temp: Double?
        let feels_like: Double?
        let pressure: Int?
        let humidity: Int?
        let temp_min: Double?
        let temp_max: Double?
        let sea_level: Double?
        let grnd_level: Double?
    }
    
    struct Wind: Codable {
        let speed: Double?
        let deg: Int?
        let gust: Double?
    }
    
    struct Clouds: Codable {
        let all: Int?
    }
    
    struct Rain: Codable {
        let _1h: Double?
        let _3h: Double?
        
        private enum CodingKeys: String, CodingKey {
            case _1h = "1h"
            case _3h = "3h"
        }
    }
    
    struct Snow: Codable {
        let _1h: Double?
        let _3h: Double?
        
        private enum CodingKeys: String, CodingKey {
            case _1h = "1h"
            case _3h = "3h"
        }
    }
    
    struct Sys: Codable {
        let type: Int?
        let id: Int?
        let message: Double?
        let country: String?
        let sunrise: Int?
        let sunset: Int?
    }
    
    private enum CodingKeys: String, CodingKey {
        case coord
        case weather
        case base
        case main
        case visibility
        case wind
        case clouds
        case rain
        case snow
        case dt
        case sys
        case timezone
        case id
        case name
        case cod
        case message
    }
    
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let rain: Rain?
    let snow: Snow?
    let dt: Int?
    let sys: Sys?
    let timezone: Int?
    let id: Int?
    let name: String?
    let cod: Int?
    let message: String?    // for error message when cod != NetworkManager.shared.apiSuccessCode
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        coord = try? container.decodeIfPresent(Coord.self, forKey: .coord)
        weather = try? container.decodeIfPresent([Weather].self, forKey: .weather)
        base = try? container.decodeIfPresent(String.self, forKey: .base)
        main = try? container.decodeIfPresent(Main.self, forKey: .main)
        visibility = try? container.decodeIfPresent(Int.self, forKey: .visibility)
        wind = try? container.decodeIfPresent(Wind.self, forKey: .wind)
        clouds = try? container.decodeIfPresent(Clouds.self, forKey: .clouds)
        rain = try? container.decodeIfPresent(Rain.self, forKey: .rain)
        snow = try? container.decodeIfPresent(Snow.self, forKey: .snow)
        dt = try? container.decodeIfPresent(Int.self, forKey: .dt)
        sys = try? container.decodeIfPresent(Sys.self, forKey: .sys)
        timezone = try? container.decodeIfPresent(Int.self, forKey: .timezone)
        id = try? container.decodeIfPresent(Int.self, forKey: .id)
        name = try? container.decodeIfPresent(String.self, forKey: .name)
        cod = try? container.decodeIfPresent(Int.self, forKey: .cod)
        message = try? container.decodeIfPresent(String.self, forKey: .message)
    }
}
