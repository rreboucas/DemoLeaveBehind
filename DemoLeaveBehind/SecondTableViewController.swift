//
//  SecondTableViewController.swift
//  DemoLeaveBehind
//
//  Created by Rodrigo Reboucas on 9/15/15.
//  Copyright © 2015 Salesforce Inc. All rights reserved.
//

import Foundation
import UIKit
import EventKit




class SecondTableViewController: UITableViewController {
    
    var SecondTableArray = [String]()
    var TrialChosen = Trial()
    var eventsList: [EKEvent] = []
    var selectedEventIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Working with EventKit
        
        let eventStore = EKEventStore()
        
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
            granted, error in
            
            if granted{
                
                var calendars = eventStore.calendarsForEntityType(EKEntityType.Event)
                
                var startDate = self.getFloatingDate(-5)!
                var endDate = self.getFloatingDate(5)!
                
                
                var pred = eventStore.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: calendars)
                var events = eventStore.eventsMatchingPredicate(pred) as [EKEvent]
                

                for event in events {
                    if (event.attendees?.count > 0){
                        
                        var evTitle = event.title
                        var evStartDate = event.startDate
                        var participants = event.attendees

                        self.eventsList.append(event)
                        
                    }
                    
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    
                })

                
            }
            else {
                print ("Access to store not granted")
                print(error)
                
            }
            
        })
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var Cell = self.tableView.dequeueReusableCellWithIdentifier("SecondCell", forIndexPath: indexPath) as! EventCustomCell
        
        var event : EKEvent! = eventsList[indexPath.row]
        Cell.MainTitle.text = event.title as! String
        
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .ShortStyle
        
        let dateString = formatter.stringFromDate(event.startDate)
        
        
        Cell.SeconDaryTitle.text = dateString
        Cell.acsImage.image = UIImage(named: "calendar.png")

        
        return Cell
    }
    
    func getFloatingDate(daysToAdd: Int) -> NSDate?  {
        let userCalendar = NSCalendar.currentCalendar()
        let currentDate = NSDate()
        let components = NSDateComponents()
        let calOptions = NSCalendarOptions()
        components.day = daysToAdd
        return userCalendar.dateByAddingComponents(components, toDate: currentDate, options: calOptions) as NSDate?
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow!
        var indexNum = indexPath.item
        
        var DestViewController = segue.destinationViewController as! ThirdTableViewController
        
        var eventToSend = eventsList[indexNum]
        var eventAttendees = eventToSend.attendees as [EKParticipant]?
        
        var TrialUpdated = self.TrialChosen
        TrialUpdated.attendees = eventAttendees
        
        DestViewController.TrialChosen = TrialUpdated
    }
    
}
