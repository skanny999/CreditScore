//
//  NetworkManager.swift
//  CreditScore
//
//  Created by Riccardo on 20/07/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static let url = URL(string: "https://5lfoiyb0b3.execute-api.us-west-2.amazonaws.com/prod/mockcredit/values")!
    
    static func getCreditReportData(completion: @escaping (Data?, CreditScoreError?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                completion(nil, CreditScoreError.networkCallFailed(error))
                return
            }
            
            guard let response  = response as? HTTPURLResponse else {
                completion(nil, CreditScoreError.networkCallFailed(nil))
                return
            }
            
            if  response.statusCode == 200 {
                completion(data, nil)
                
            } else {
                let error = NSError(domain: response.debugDescription, code: response.statusCode, userInfo: nil)
                completion(nil, CreditScoreError.networkCallFailed(error))
            }
        }
        
        session.resume()
    }

}
