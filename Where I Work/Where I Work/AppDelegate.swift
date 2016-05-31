//
//  AppDelegate.swift
//  Where I Work
//
//  Created by Sean Wernimont on 3/6/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
       GMSServices.provideAPIKey(Constants.APIKeys.GooglePlaces)
        return true
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
}

