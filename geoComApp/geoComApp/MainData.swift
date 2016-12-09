//
//  MainData.swift
//  geoComApp
//
//  Created by Ranjit Marathay on 12/5/16.
//  Copyright © 2016 Ranjit Marathay. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation
import Stripe

class MainData: NSObject{
    static var dataRef = FIRDatabase.database().reference()
    static var userRef = dataRef.child(userId)
    
    static var username = "";
    static var userId = "";
    
    
    // Card Information
    static var cardNumber = "";
    static var expMonth = 00;
    static var expYear = 0000;
    static var cvcNumber = "";
    static var userEmail = "";
    
    // Database structure
    
    static var data: [[String:String]] = [ ]
    
    static var keys: [String] = [ ]

}
