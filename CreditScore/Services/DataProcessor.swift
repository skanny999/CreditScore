//
//  DataProcessor.swift
//  CreditScore
//
//  Created by Riccardo on 20/07/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

class DataProcessor {
    
    static func process(data: Data) throws -> CreditReport? {
        
            let root = try JSONDecoder().decode(Root.self, from: data)
            return root.creditReportInfo
    }

}
