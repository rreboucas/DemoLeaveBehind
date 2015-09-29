//
//  LoginScreenController.swift
//  DemoLeaveBehind
//
//  Created by Rodrigo Reboucas on 9/16/15.
//  Copyright © 2015 Salesforce Inc. All rights reserved.
//

import Foundation
import UIKit

class LoginScreenController: UIViewController, SFAuthenticationManagerDelegate {
 
    @IBAction func btn_Tapped(sender: AnyObject) {
        SalesforceSDKManager.sharedManager().launch()
    }
    

    @IBAction func btn_Logout(sender: AnyObject) {
        //SFUserAccountManager.sharedInstance().currentUser = SFUserAccountManager.sharedInstance().allUserAccounts[0] as! SFUserAccount;
        //var creds: SFOAuthCredentials = SFOAuthCredentials(identifier: <#T##String!#>, clientId: <#T##String!#>, encrypted: <#T##Bool#>)
        //var coordinator = SFOAuthCoordinator(credentials: creds)
        //SFOAuthCoordinator.revokeAuthentication(coordinator)
        SFAuthenticationManager.sharedManager().logout()
        SalesforceSDKManager.sharedManager().launch()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Navigation back button for next view
        let backItem = UIBarButtonItem(title: "", style: .Bordered, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        SalesforceSDKManager.sharedManager().launch()
    }
    
    func authManagerDidAuthenticate(manager: SFAuthenticationManager!, credentials: SFOAuthCredentials!, authInfo info: SFOAuthInfo!) {
        print("got here")
    }
    
    
    func authManagerDidFinish(manager: SFAuthenticationManager!, info: SFOAuthInfo!) {
        
        if !SFUserAccountManager.sharedInstance().currentUser.userName.isEmpty {
            //call the segue with the name you give it in the storyboard editor
            self.performSegueWithIdentifier("ldin", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "history" {
            let vc = segue.destinationViewController as UIViewController
            vc.navigationItem.title = "Trial Request History"
            navigationItem.title = "Home"
        }
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        print("Got here")
    }
    
    
    
}
