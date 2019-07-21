//
//  Score.swift
//  CreditScore
//
//  Created by Riccardo on 20/07/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

struct Root: Codable {
    
    let creditReportInfo: CreditReport?
}


struct CreditReport: Codable {
    
    let score: Int?
    let maxScoreValue: Int?
    let minScoreValue: Int?
}
