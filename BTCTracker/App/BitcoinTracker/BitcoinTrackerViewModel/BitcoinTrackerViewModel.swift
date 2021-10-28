//
//  BitcoinTrackerViewModel.swift
//  BTCTracker
//
//  Created by Sachin Ambegave on 21/10/21.
//

import Foundation

typealias completion = (_ error: Bool,_ message: String,_ trackerModel: BitcoinTrackerModel?) -> Void
typealias result = (_ error: Bool,_ message: String,_ currencies: [Currency]?) -> Void

protocol BitcoinTrackerProtocol {
    var currencies: [Currency]? {get set}
    func fetchData(completion: @escaping result)
}

class BitcoinTrackerViewModel : BitcoinTrackerProtocol {
    var currencies: [Currency]? = []
    
    func fetchData(completion: @escaping result) {
        getBitcoinDataFromServer { error, message, trackerModel in
            if let model = trackerModel {
                let mirrored_object = Mirror(reflecting: model.bpi!)
                
                for (_, attr) in mirrored_object.children.enumerated() {
                    if let propertyName = attr.label as String? {
//                        print("Attr \(index): \(propertyName) = \(attr.value)")
                        self.currencies?.append(Currency(name: propertyName, value: attr.value as? Eur))
                    }
                }
            }
            threadOnMain {
                completion(error, message, self.currencies)
            }
        }
    }
    
    private func getBitcoinDataFromServer(completion: @escaping completion) {
        let url = URL(string: Constants.Network.BaseURL)!
        
        /// execute completion block on main thread as URLSession is being executed from background thread internally
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil || data == nil {
                threadOnMain {
                    completion(true, "Client error!", nil)
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                threadOnMain {
                    completion(true, "Server error!", nil)
                }
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode(BitcoinTrackerModel.self, from: data!)
                
                threadOnMain {
                    completion(false, "Success", responseObject)
                }
            } catch {
                threadOnMain {
                    completion(true, error.localizedDescription, nil)
                }
            }
            //            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
}
