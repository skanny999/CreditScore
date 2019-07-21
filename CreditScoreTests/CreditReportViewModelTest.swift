//
//  CreditScoreTests.swift
//  CreditScoreTests
//
//  Created by Riccardo on 20/07/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import XCTest
@testable import CreditScore

class CreditReportViewModelTest: XCTestCase {

    override func setUp() {
        
    }

    override func tearDown() {
        
    }

    func testCreditReportViewModel() {
        
        let creditData = FileExtractor.extractJsonFile(withName: "Model", forClass: type(of: self))
        
        let viewModel = CreditReportViewModel(withTestData: creditData)
        
        XCTAssert(viewModel.minimumScore == "0")
        XCTAssert(viewModel.maximumScore == "out of 700")
        XCTAssert(viewModel.userScore == 514)
        XCTAssert(viewModel.valuePercentage == 0.7342857143, String(viewModel.valuePercentage))
    }

}
