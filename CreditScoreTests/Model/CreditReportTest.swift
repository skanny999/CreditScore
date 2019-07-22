//
//  CreditReportTest.swift
//  CreditScoreTests
//
//  Created by Riccardo on 20/07/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import XCTest
@testable import CreditScore

class CreditReportTest: XCTestCase {

    override func setUp() {

    }

    func testCreditReportObject() {
        
        let data = FileExtractor.extractJsonFile(withName: "Model", forClass: type(of: self))
        
        let creditReport = try! DataProcessor.process(data: data)
        
        XCTAssert(creditReport?.minScoreValue == 0)
        XCTAssert(creditReport?.maxScoreValue == 700)
        XCTAssert(creditReport?.score == 514)
    }

}
