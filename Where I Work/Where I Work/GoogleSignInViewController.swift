//
//  GoogleSignInViewController.swift
//  Where I Work
//
//  Created by Sean Wernimont on 10/4/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//

import Foundation
import UIKit
import Google
import GoogleSignIn

class GoogleSignInViewController : BaseViewController, GIDSignInUIDelegate{
    
    @IBOutlet weak var signInButton : GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Uncomment to automatically sign in the user.
        GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
    }
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        print("google sign in view controller dismiss")
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        print("google sign in view controller will dispatch")
        if(error == nil){
            performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        if(signIn.currentUser != nil){
            let profile = signIn.currentUser.profile
            
            print("Name: \(profile?.name)")
            print("Given Name: \(profile?.givenName!)")
            print("Family Name: \(profile?.familyName!)")
            print("Email: \(profile?.email!)")
            print("Has Image: \(profile?.hasImage)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        print("google sign in view controller present")
    }
}
