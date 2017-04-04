//
//  ContextualEngine.swift
//  Chevents
//
//  Created by Bid Sharma on 11/1/16.
//  Copyright © 2016 Bid Sharma. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

extension UserTableVC{
    
    func registerCards(){
        let allCards = getCards()
        for (_ , card) in allCards{
            tableView.register(UINib(nibName: card.nibName, bundle: nil), forCellReuseIdentifier: card.cellRID)
        }
    }
    
    func getCards() -> [String : card]{
        let cards:[String : card] = ["WelcomeCard" : card(nibName: "WelcomeCard", cellRID: "welcome", cellHeight: 150.0),
                                     "MenuCard" : card(nibName: "MenuCard", cellRID: "menu", cellHeight: 50.0),
                                     "EventCard" : card(nibName: "EventCard", cellRID: "event", cellHeight:250.0 ),
                                     "CreateEventCell": card(nibName: "CreateEventCell", cellRID: "create", cellHeight:250.0 ),
                                     "SummaryCard" : card(nibName: "SummaryCard", cellRID: "summary", cellHeight:100.0)]
        return cards
    }
    
    func loadUserData(){
        let uid = FIRAuth.auth()?.currentUser?.uid
        RestApiManager.sharedInstance.getUser(uid: uid!, onCompletion:{
            (json) in
            let username = json["name"].string
            let ifOrg = json["org"].bool
            let id = json["id"].string
            if username != nil {
                OperationQueue.main.addOperation {
                    self.setSession(org: ifOrg!,id:id!,username:username!)
                    self.allData.append(["username" : username as AnyObject])
                    self.dataCardTypes.append("WelcomeCard")
                    self.allData.append(["menuTitle" : "Upcoming Events" as AnyObject])
                    self.dataCardTypes.append("MenuCard")
                    self.loadEventData()
                    self.tableView.reloadData()
                }
            }else{
                //do something to handle database connection failure
            }
        })
    }
    
    func getCell(currentCard: card, indexPath: IndexPath, data: [String:AnyObject])-> Any{
        switch currentCard.nibName {
        case "WelcomeCard":
            let welcomeCard = WelcomeCard()
            return welcomeCard.returnSelfCell(tableView: tableView, reuseId: currentCard.cellRID, indexPath: indexPath, username: data["username"] as! String)
        case "MenuCard":
            let menuCard = MenuCard()
            return menuCard.returnSelfCell(tableView: tableView, reuseId: currentCard.cellRID, indexPath: indexPath)
        case "EventCard":
            let eventCard = EventCard()
            return eventCard.returnSelfCell(tableView: tableView, reuseId: currentCard.cellRID, indexPath: indexPath, data: data)
        case "CreateEventCell":
            let createEventCell = CreateEventCell()
            return createEventCell.returnSelfCell(tableView: tableView, reuseId: currentCard.cellRID, indexPath: indexPath, data: data)
        case "SummaryCard":
            let summaryCell = SummaryCard()
            return summaryCell.returnSelfCell(tableView: tableView, reuseId: currentCard.cellRID, indexPath: indexPath, data: data)
        default:
            return ""
        }
    }
    
    func loadEventData(){
        let isUserOrg = MySession.sharedInstance.isUserOrg
        let menuIndex =  MySession.sharedInstance.currentIndex
        let uid : String = (FIRAuth.auth()?.currentUser?.uid)!
        if(isUserOrg){
            switch menuIndex {
            case 0:
                //Create a new Event
                self.allData.append(["name":"" as AnyObject,"location":"" as AnyObject,"date":"" as AnyObject,
                                     "description": "" as AnyObject, "time":"" as AnyObject])
                self.dataCardTypes.append("CreateEventCell")
            case 1:
                //Upcoming Events
                let url = "\(uid)/organizer/upcoming-events"
                self.allEventsOfOrg(url: url, cardName: "EventCard")
            case 2:
                //Past Events
                let url = "\(uid)/organizer/past-events"
                self.allEventsOfOrg(url: url, cardName: "EventCard")
                
            case 3:
                //Summary
                let url = "\(uid)/organizer/summary"
                RestApiManager.sharedInstance.doGetRequest(url: url, onCompletion: {
                    (json) in
                    OperationQueue.main.addOperation {
                        self.allData.append(json.dictionaryObject as! [String : AnyObject])
                        self.dataCardTypes.append("SummaryCard")
                        self.tableView.reloadData()
                    }
                })
            default:
                break
            }
            
        }else{
            switch menuIndex {
            case 0:
                //Upcoming Events
                let url = "\(uid)/event/list/upcoming"
                self.allEventsOfOrg(url: url, cardName: "EventCard")
            case 1:
                //Subscribed Events
                let url = "\(uid)/user/event/upcoming"
                self.allEventsOfOrg(url: url, cardName: "EventCard")
            case 2:
                //Past Events
                let url = "\(uid)/user/event/past"
                self.allEventsOfOrg(url: url, cardName: "EventCard")
            default:
                break
            }
        }
    }

    func setSession(org: Bool, id:String, username:String) {
        MySession.sharedInstance.id = id
        MySession.sharedInstance.name = username
        MySession.sharedInstance.currentIndex = 0
        if(org){
            MySession.sharedInstance.isUserOrg = true
            MySession.sharedInstance.menuItems = ["Create a new Event","Upcoming Events", "Past Events", "Summary"]
        }else{
            MySession.sharedInstance.isUserOrg = false
            MySession.sharedInstance.menuItems = ["Upcoming Events", "Subscribed Events", "Past Events"]
        }
    }
    
    func allEventsOfOrg(url: String, cardName: String) {
        RestApiManager.sharedInstance.doGetRequest(url: url, onCompletion: {
            (json) in
            OperationQueue.main.addOperation {
                for (key, _) in json{
                    let dataString = json[key].rawString()
                    let jsonData = JSON.parse(dataString!).dictionaryObject
                    self.allData.append(jsonData as! [String : AnyObject])
                    self.dataCardTypes.append(cardName)
                }
                self.tableView.reloadData()
            }
        })
    }
}
