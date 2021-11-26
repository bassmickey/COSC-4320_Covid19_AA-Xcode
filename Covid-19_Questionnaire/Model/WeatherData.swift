//
//  WeatherData.swift
//  Covid-19_Questionnaire
//
//  Created by Miguel Barajas on 11/26/21.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}
struct Weather: Codable {
    let id: Int
    let description: String
}
