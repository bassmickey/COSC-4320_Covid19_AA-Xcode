//
//  PollenData.swift
//  Covid-19_Questionnaire
//
//  Created by Miguel Barajas on 11/26/21.
//

import Foundation

struct PollenData: Codable {
    let data: [DataJSON]
}

struct DataJSON: Codable {
    let Risk: Risk
}

struct Risk: Codable {
    let grass_pollen: String
    let tree_pollen: String
    let weed_pollen: String
}
