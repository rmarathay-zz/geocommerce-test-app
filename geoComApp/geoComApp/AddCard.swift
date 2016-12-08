//
//  AddCard.swift
//  geoComApp
//
//  Created by Ranjit Marathay on 12/7/16.
//  Copyright © 2016 Ranjit Marathay. All rights reserved.
//

import UIKit
import Stripe
import AFNetworking
import Alamofire

class AddCard: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var cardNum: UITextField!
    @IBOutlet weak var exp: UITextField!
    @IBOutlet weak var cvc: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var jsonLabel: UILabel!
    
    
    var stripeView = STPAddCardViewController();
    
    func postStripeToken(token: STPToken) {
        NSLog("Inside postStripeToken")
        let URL = "https://geocomapp.herokuapp.com/"
        let params = ["stripeToken": token.tokenId,
                      "amount": "10",
                      "currency": "usd",
                      "description": MainData.userEmail] as [String : Any]
        
        Alamofire.request(URL, method: .post, parameters: params).responseJSON{
            response in
            print(response.request!)
            print(response.response!)
            print(response.result)
            if(String(describing: response.result) == "FAILURE"){
                NSLog("There is an issue")
            }
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let stripeCard = STPCardParams();
        NSLog("Inside saveButton")
        MainData.userEmail = email.text!
        MainData.cardNumber = cardNum.text!
        MainData.cvcNumber = self.cvc.text!;
        if(self.exp.text?.isEmpty == false){
            let expirationDate = self.exp.text?.components(separatedBy: "/")
            MainData.expYear = Int(expirationDate![1])!
            MainData.expMonth = Int(expirationDate![0])!
        }
    
        stripeCard.number = MainData.cardNumber
        stripeCard.cvc = MainData.cvcNumber
        stripeCard.expMonth = UInt(MainData.expMonth)
        stripeCard.expYear = UInt(MainData.expYear)

        if STPCardValidator.validationState(forCard: stripeCard) != .valid{
            NSLog("INVALID")
        }

        STPAPIClient.shared().createToken(withCard: stripeCard, completion: { (token, error) -> Void in
            NSLog(".createToken")
            if error != nil {
                
                self.handleError(error: error! as NSError)
                return
            } 
            else{
                NSLog("calling postStripeToken")
                self.postStripeToken(token: token!)
            }
        })
        let MainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let MapViewController: UIViewController = MainStoryBoard.instantiateViewController(withIdentifier: "Map");
        self.present(MapViewController, animated: true, completion: nil);
    }
    
    func handleError(error: NSError) {
        let alert = UIAlertController(title: "Please Try Again", message: String(describing: error), preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func payButton(_ sender: Any) {
        NSLog("payButton")
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.email.text = MainData.userEmail
        self.cardNum.text = MainData.cardNumber
        var temp = String()
        temp += String(MainData.expMonth)
        temp += "/"
        temp += String(MainData.expYear)
        self.exp.text = temp
        self.cvc.text = MainData.cvcNumber
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
