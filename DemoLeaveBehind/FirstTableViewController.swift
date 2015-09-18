//
//  ViewController.swift
//  DemoLeaveBehind
//
//  Created by Rodrigo Reboucas on 9/15/15.
//  Copyright © 2015 Salesforce Inc. All rights reserved.
//

import UIKit
import Foundation

class FirstTableViewController: UITableViewController, SFRestDelegate{
    
    var FirstTableArray = [String]()
    var SecondArray = [SecondTable]()
    var dataRows = NSArray()
    var lstTrials = [Trial]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //logout()
        
        //FirstTableArray = ["First", "Second", "Third"]
        SecondArray = [SecondTable(secondTitle: ["FirstFirst", "SecondFirst", "ThirdFirst"] , pic: ""),
            SecondTable(secondTitle: ["FirstSecond", "SecondSecond", "ThirdSecond"] , pic: ""),
            SecondTable(secondTitle: ["FirstThird", "SecondThird", "ThirdThird"] , pic: "")]
        
        
        // Register for IOS Local Notifications
        let settings = UIUserNotificationSettings(forTypes: .Alert, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        // Do any additional setup after loading the view, typically from a nib.
        //loadTrials()
        
        var sharedInstance = SFRestAPI.sharedInstance()
        
        
        var request = sharedInstance.requestForQuery("SELECT Id,name, lc_trialforce__Template_Logo__c, lc_trialforce__Active__c,lc_trialforce__Application_Logo__c,lc_trialforce__Connected_App_Callback_URL__c,lc_trialforce__Connected_App_Consumer_Key__c,lc_trialforce__Signup_Email_Suppressed__c,lc_trialforce__Subdomain__c,lc_trialforce__Trialforce_Template_ID__c,lc_trialforce__Version__c FROM lc_trialforce__Trial_App_Template__c WHERE lc_trialforce__Active__c = 'True' ORDER BY Name, lc_trialforce__Version__c")
        
        
        
        sharedInstance.send(request, delegate: self)

    }
    
    func request(request: SFRestRequest?, didLoadResponse jsonResponse: AnyObject) {
        var records = jsonResponse.objectForKey("records") as! NSArray?
        if records != nil {
            self.dataRows = records!
            
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                
            })
            
            
            // Populate Array of Trials with Results
            var count = 0
            for dataRow in dataRows {
                var obj : AnyObject! =  dataRows.objectAtIndex(count)
                var theTrial = Trial(
                    templateName: obj.objectForKey("Name") as! String,
                    firstName: nil,
                    lastName: nil,
                    email: nil,
                    userName: nil,
                    trialTemplateID: obj.objectForKey("lc_trialforce__Trialforce_Template_ID__c") as! String?,
                    companyName: nil,
                    countryCode: nil,
                    connectedAppCallBackURL: obj.objectForKey("lc_trialforce__Connected_App_Callback_URL__c") as? String,
                    signupEmailSuppressed: obj.objectForKey("lc_trialforce__Signup_Email_Suppressed__c") as! Bool?,
                    connectedAppConsummerKey: obj.objectForKey("lc_trialforce__Connected_App_Consumer_Key__c") as? String,
                    subdomain: obj.objectForKey("lc_trialforce__Subdomain__c") as? String,
                    attendees: nil
                
                )
                self.lstTrials.append(theTrial)
                count = count + 1
            }
            
            
        }
    }
    

   
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return FirstTableArray.count
        return self.dataRows.count;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var Cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var obj : AnyObject! =  dataRows.objectAtIndex(indexPath.row)
        var name = obj.objectForKey("Name") as! String
        Cell.textLabel!.text = obj.objectForKey("Name") as! String
        
        Cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        var imgbyte = obj.objectForKey("lc_trialforce__Template_Logo__c") as! String
        var imgCru = NSData(base64EncodedString: imgbyte, options: NSDataBase64DecodingOptions())
        
        var img: UIImage = UIImage(data: imgCru!)!
        Cell.imageView?.image = resizeImage(img, toTheSize: CGSize(width: 70, height: 50))
        Cell.imageView?.clipsToBounds = true
        Cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        
        //Cell.textLabel?.text = FirstTableArray[indexPath.row]
    
        
        
        return Cell

        
        
    }
    
    func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{
        
        
        var scale = CGFloat(max(size.width/image.size.width,
            size.height/image.size.height))
        var width:CGFloat  = image.size.width * scale
        var height:CGFloat = image.size.height * scale;
        
        var rr:CGRect = CGRectMake( 0, 0, width, height);
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.drawInRect(rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow!
        
        var DestViewController = segue.destinationViewController as! SecondTableViewController
        
        var SecondTableArrayTwo = SecondArray[indexPath.row]
        
        DestViewController.SecondTableArray = SecondTableArrayTwo.secondTitle
        DestViewController.TrialChosen = lstTrials[indexPath.row]
    }
    
}

