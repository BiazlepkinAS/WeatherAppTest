
import Foundation
import CoreLocation

struct DataHandler {
    
    static func getData(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Weather?, Error?) -> Void) {
        
        APIHandler.request(latitude: latitude, longitude: longitude) { (data, error) in
            guard let data = data else {return}
            
            switch error {
            case nil:
                Storage.save(data: data, fileName: Constants.fileName)
                do {
                    let weatherData = try JSONDecoder().decode(Weather.self, from: data)
                    DispatchQueue.main.async {
                        completion(weatherData, nil)
                    }
                } catch let jsonError {
                    print("Failed to decode JSON ", jsonError)
                }
            default:
                completion(nil, error)
            }
        }
    }
    
    static func getWeatherFromCashe (completion: @escaping (Weather) -> Void) {
        guard let dataFromFile = Storage.read(fileName: Constants.fileName) else { return }
        do {
            let weatherData = try JSONDecoder().decode(Weather.self, from: dataFromFile)
            DispatchQueue.main.async {
                completion(weatherData)
            }
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
        }
    }
}
