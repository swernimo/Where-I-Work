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
    let viewController = RateLocationViewController()
    
    override func setUp() {
        super.setUp()
        viewController.freeWifiSwitch = UISwitch()
        viewController.workThereAgainSwitch = UISwitch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_FillMode_ShouldSetToHalf() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let control = CosmosView()
        control.settings.fillMode = .full
        
        viewController.setFillModeForRatingControls([control])
        
        XCTAssert(control.settings.fillMode == .half)
    }
    
    func test_setRatingControl_freeWifiSwitch_ShouldBe_Off(){
        viewController.freeWifiSwitch.isOn = true;
        viewController.setRatingControlsToDefaultState()
        
        XCTAssert(viewController.freeWifiSwitch.isOn == false)
    }
    
    func test_setRatingControl_workThereAgainSwitch_ShouldBe_Off(){
        viewController.workThereAgainSwitch.isOn = true;
        viewController.setRatingControlsToDefaultState()
        
        XCTAssert(viewController.workThereAgainSwitch.isOn == false)
    }
}
