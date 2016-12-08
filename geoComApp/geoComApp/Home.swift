//
//  HomeView.swift
//  geoComApp
//
//  Created by Ranjit Marathay on 11/21/16.
//  Copyright © 2016 Ranjit Marathay. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit

class Home: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var homeLabel: UILabel!
    
    let loginButton: FBSDKLoginButton = FBSDKLoginButton()
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isHidden = true;
        nextButton.isHidden = true
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if (user != nil){
                self.nextButton.isHidden = false
                self.nextButtonTapped(sender: self.nextButton)
            }
            else{
                // Optional: Place the button in the center of your view.
                self.loginButton.center = self.view.center
                self.loginButton.readPermissions = ["public_profile", "email", "user_friends"];
                self.loginButton.delegate = self;
                self.view!.addSubview(self.loginButton)
                self.loginButton.isHidden = false;
            }
        };
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextButtonTapped(sender: UIButton){
        let MainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let MapViewController: UIViewController = MainStoryBoard.instantiateViewController(withIdentifier: "Map");
        self.present(MapViewController, animated: true, completion: nil);
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        self.loginButton.isHidden = true;
        if(error != nil){
            self.loginButton.isHidden = false;
        }
        else if(result.isCancelled){
            self.loginButton.isHidden = false;
        }
        else{
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            print("User Logged In to Facebook");
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                print("User Logged In to Firebase");
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out");
    }
}
