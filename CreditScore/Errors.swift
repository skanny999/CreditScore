//
//  Errors.swift
//  CreditScore
//
//  Created by Riccardo on 20/07/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

enum CreditScoreError: Error {
    
    case networkCallFailed(_ error: Error?)
    case parsingDataFailed(_ error: Error?)
    
}

extension CreditScoreError {
    
    var userDescription: String {
        
        switch self {
        case .networkCallFailed:
            return "There was a problem downloading the data from the internet"
        case .parsingDataFailed:
            return "There was a problem processing the data downloaded from the internet"
        }
    }
}
