//
//  UserTableVC.swift
//  Chevents
//
//  Created by Bid Sharma on 10/21/16.
//  Copyright © 2016 Bid Sharma. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserTableVC: UITableViewController {
    
    var allCards = [String : card]()
    var allData = [Dictionary<String,AnyObject>]();
    var dataCardTypes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(UserTableVC.reloadTableData(notification:)), name: NSNotification.Name(rawValue: "reload"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UserTableVC.removeCell(notification:)), name: NSNotification.Name(rawValue: "remove"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UserTableVC.edit(notification:)), name: NSNotification.Name(rawValue: "edit"), object: nil)

        self.registerCards()
        self.allCards = self.getCards()
        self.loadUserData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentData = allData[indexPath.row]
        let currentType = dataCardTypes[indexPath.row]
        let currentCard = allCards[currentType]
        return self.getCell(currentCard: currentCard!, indexPath: indexPath, data: currentData) as! UITableViewCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentType = dataCardTypes[indexPath.row]
        let currentCard = allCards[currentType]
        return  CGFloat((currentCard?.cellHeight)!)
    }
    
    func reloadTableData(notification: NSNotification) {
        self.allData = [self.allData[0], self.allData[1]]
        self.dataCardTypes = [self.dataCardTypes[0], self.dataCardTypes[1]]
        self.loadEventData()
        self.tableView.reloadData()
    }
    
    func removeCell(notification: NSNotification){
        let indexPath = notification.userInfo?["indexPath"] as! IndexPath
        let row = indexPath.row
        self.allData.remove(at: row)
        self.dataCardTypes.remove(at: row)
        self.tableView.reloadData()
    }
    
    func edit(notification: NSNotification) {
        let indexPath = notification.userInfo?["indexPath"] as! IndexPath
        let row = indexPath.row
        let dataToEdit = self.allData[row]
        self.allData = [self.allData[0], self.allData[1], dataToEdit]
        self.dataCardTypes = [self.dataCardTypes[0], self.dataCardTypes[1], "CreateEventCell"]
        MySession.sharedInstance.currentIndex = 0
        self.tableView.reloadData()
    }
}

