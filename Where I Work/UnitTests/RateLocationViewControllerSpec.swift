//
//  RateLocationViewControllerSpec.swift
//  Where I Work
//
//  Created by Sean Wernimont on 5/28/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//

import Quick
import Nimble
import Where_I_Work
import Cosmos

@testable import Where_I_Work

class RateLocationViewControllerSpec : QuickSpec{
    override func spec(){
        describe("Rate Location View Controller"){
            describe("set Fill Mode For Rating Controls"){
                it("should set the fill mode to half for all rating controls"){
                    let control = CosmosView()
                    let viewController = RateLocationViewController()
                    
                    control.settings.fillMode = .Full
                    
                    viewController.setFillModeForRatingControls([control])
                    
                    expect(control.settings.fillMode).to(equal(StarFillMode.Half))
                }
            }
        }
    }
}