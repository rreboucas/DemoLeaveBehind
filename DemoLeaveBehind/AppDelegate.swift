//
//  AppDelegate.swift
//  DemoLeaveBehind
//
//  Created by Rodrigo Reboucas on 9/15/15.
//  Copyright © 2015 Salesforce Inc. All rights reserved.
//

import UIKit
import CoreData
import WatchKit
import WatchConnectivity

let templtHelper: TrialTemplateHelper = TrialTemplateHelper()
let RemoteAccessConsumerKey = "3MVG9SemV5D80oBe_O4cXHa0F86AARqRtdUc5qflyc4Dk_vVTeydccxd4rUAuIvzFpehR_uFwhwSNvqzTG0.b";
let OAuthRedirectURI = "testsfdc://oauth/success";
let scopes = ["api"];
var watchData = [String: AnyObject]()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?
    var watchSession : WCSession?
    
    


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        print("AppDelegate - registering for WatchKit sessions")
        
        if(WCSession.isSupported()){
            watchSession = WCSession.defaultSession()
            watchSession!.delegate = self
            watchSession!.activateSession()
        }
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    override init() {
        
        
        super.init()
        SFLogger.setLogLevel(SFLogLevelDebug)
        
        // TEST
        //SFAuthenticationManager.sharedManager().logout()
        
        SalesforceSDKManager.sharedManager().connectedAppId = RemoteAccessConsumerKey
        SalesforceSDKManager.sharedManager().connectedAppCallbackUri = OAuthRedirectURI
        SalesforceSDKManager.sharedManager().authScopes = scopes
        SalesforceSDKManager.sharedManager().postLaunchAction = {
            [unowned self] (launchActionList: SFSDKLaunchAction) in
            let launchActionString = SalesforceSDKManager.launchActionsStringRepresentation(launchActionList)
            self.log(SFLogLevelInfo, msg:"Post-launch: launch actions taken: \(launchActionString)");
            
        }
        SalesforceSDKManager.sharedManager().launchErrorAction = {
            [unowned self] (error: NSError?, launchActionList: SFSDKLaunchAction) in
            if let actualError = error {
                self.log(SFLogLevelError, msg:"Error during SDK launch: \(actualError.localizedDescription)")
            } else {
                self.log(SFLogLevelError, msg:"Unknown error during SDK launch.")
            }
            //  self.initializeAppViewState()
            // SalesforceSDKManager.sharedManager().launch()
        }
        SalesforceSDKManager.sharedManager().postLogoutAction = {
            [unowned self] in
            self.handleSdkManagerLogout()
        }
        SalesforceSDKManager.sharedManager().switchUserAction = {
            [unowned self] (fromUser: SFUserAccount?, toUser: SFUserAccount?) -> () in
            self.handleUserSwitch(fromUser, toUser: toUser)
        }
        
        //templtHelper.register()
        
    }
    
    func handleSdkManagerLogout()
    {
        //todo
    }
    
    func handleUserSwitch(fromUser: SFUserAccount?, toUser: SFUserAccount?)
    {
        //todo
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        print("received AppContext from watch")
        
        SalesforceSDKManager.sharedManager().launch()
        
        
        var appName = applicationContext["appName"] as! String
        var firstName = applicationContext["fName"] as! String
        var lastName = applicationContext["lName"] as! String
        var companyName = applicationContext["cName"] as! String
        var templateID = applicationContext["templateId"] as! String
        var countryCode = applicationContext["countryCode"] as! String
        var cbURL = applicationContext["cbURL"] as! String?
        var subdomain = applicationContext["subDomain"] as! String?
        var username = applicationContext["userName"] as! String
        var email = applicationContext["email"] as! String
        var consumKey = applicationContext["consKey"] as! String?
        var emailSupressed = applicationContext["mSupressed"] as! Bool?
        
        
        templtHelper.createSignupRequests(appName, firstName: firstName, lastName: lastName, companyName: companyName, templateID: templateID, countryCode: countryCode, cbURL: cbURL, subdomain: subdomain, username: username, email: email, consumKey: consumKey, emailSupressed: emailSupressed)
        
        var notifBody = "\"\(appName)\" Trial requested for \"\(email)\""
        
        
        templtHelper.createLocalIOSNotification(notifBody, fireDate: NSDate(timeIntervalSinceNow: 7))
    }


}

