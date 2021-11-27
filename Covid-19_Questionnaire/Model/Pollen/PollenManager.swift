//
//  PollenManager.swift
//  Covid-19_Questionnaire
//
//  Created by Miguel Barajas on 11/26/21.
//

import Foundation
import CoreLocation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

protocol PollenManagerDelegate {
    func didUpdatePollen(_ pollenManager: PollenManager, pollen: PollenModel)
    func pollenDidFailWithError(error: Error)
}

struct PollenManager {
    var delegate: PollenManagerDelegate?
    var semaphore = DispatchSemaphore (value: 0)
    let pollenURL = "https://api.ambeedata.com/latest/pollen/"
    
    /// builds the API URL based on coordinates
    func fetchPollen(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(pollenURL)by-lat-lng?lat=\(latitude)&lng=\(longitude)"
        buildApiKey(with: urlString)
    }
    
    /// builds the API URL based on a city name
    func fetchPollen(cityName: String) {
        let urlString = "\(pollenURL)by-place?place=\(cityName)"
        buildApiKey(with: urlString)
    }
    
    /// adds the key complying to REST protocols
    func buildApiKey(with urlString: String) {
        var request = URLRequest(url: URL(string: urlString)!,timeoutInterval: Double.infinity)
        
        request.addValue("84c4798cc1b2e91be46e8677ca80fc89f287fe3cd5cf1947970ceecd32d90a0c", forHTTPHeaderField: "x-api-key")
        
        request.httpMethod = "GET"
        
        pollenPerformRequest(with: request)
    }
    
    /// performs an API call
    func pollenPerformRequest(with request: URLRequest) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                self.delegate?.pollenDidFailWithError(error: error!)
                semaphore.signal()
                return
            }
            
            if let safeData = data {
                if let pollen = self.parseJSON(safeData) {
                    delegate?.didUpdatePollen(self, pollen: pollen)
                }
            }
            
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    
    /// Extracts data from the JSON file
    /// - Parameter pollenData: data being passed from the API call
    /// - Returns: a PollenModel object
    func parseJSON(_ pollenData: Data) -> PollenModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(PollenData.self, from: pollenData)
            let grassPollen = decodedData.data[0].Risk.grass_pollen
            let treePollen = decodedData.data[0].Risk.tree_pollen
            let weedPollen = decodedData.data[0].Risk.weed_pollen
            
            let pollen = PollenModel(grass: grassPollen, tree: treePollen, weed: weedPollen)
            return pollen
        } catch {
            delegate?.pollenDidFailWithError(error: error)
            return nil
        }
    }
}

