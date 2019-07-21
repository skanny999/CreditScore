//
//  CreditReportViewModel.swift
//  CreditScore
//
//  Created by Riccardo on 20/07/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

class CreditReportViewModel {
    
    private var creditReport: CreditReport? {
        didSet {
            if creditReport != nil {
                updateView?()
            }
        }
    }
    
    init() {

        downloadCreditData()
    }
    
    
    // testing initializer
    init(withTestData data: Data) {

        processDownloadedData(data)
    }
    
    // view updaters
    
    var displayAlert: ((CreditScoreError) -> Void)?
    var updateView: (() -> Void)?
    
    
    // view model values
    
    var minimumScore: String {
        
        if let minScore = creditReport?.minScoreValue {
            return String(minScore)
        }
        return "0"
    }
    
    var maximumScore: String {
        
        if let maxScore = creditReport?.maxScoreValue {
            return "out of \(String(maxScore))"
        }
        return "out of 0"
    }
    
    var userScore: Int {

        return creditReport?.score ?? 0
    }
    
    var valuePercentage: Float {
        
        if let userScore = creditReport?.score,
            let maxScore = creditReport?.maxScoreValue {
            
            return Float(userScore) / Float(maxScore)
        }
        return 0
    }
}

private extension CreditReportViewModel {
    
    func downloadCreditData() {
        
        NetworkManager.getCreditReportData { [weak self] (data, error) in
            
            guard let self = self else { return }
            
            if let error = error {
                self.displayAlert?(error)
                return
            }
            
            if let data = data {
                self.processDownloadedData(data)
            } else {
                self.displayAlert?(CreditScoreError.networkCallFailed(nil))
            }
        }
    }
    
    
    func processDownloadedData(_ data: Data) {
        
        do {
            let root = try JSONDecoder().decode(Root.self, from: data)
            creditReport = root.creditReportInfo
            
        } catch {
            
            displayAlert?(CreditScoreError.parsingDataFailed(error))
        }
    }
    
    
}

