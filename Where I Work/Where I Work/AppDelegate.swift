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
import GoogleSignIn
import Google

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       GMSServices.provideAPIKey(Constants.APIKeys.GooglePlaces)
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    func application(application: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        //        
        //UIApplicationOpenURLOptionsSourceApplicationKey
        return GIDSignIn.sharedInstance().handle(url as! URL, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication.rawValue
] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation.rawValue])
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
}

