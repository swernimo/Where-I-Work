//
//  RateLocationViewController.swift
//  Where I Work
//
//  Created by Sean Wernimont on 11/20/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//

import XCTest
import Cosmos

@testable import Where_I_Work

class RateLocationViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_FillMode_ShouldSetToHalf() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let vc = RateLocationViewController()
        let control = CosmosView()
        control.settings.fillMode = .full
        
        vc.setFillModeForRatingControls([control])
        
        XCTAssert(control.settings.fillMode == .half)
    }
}
