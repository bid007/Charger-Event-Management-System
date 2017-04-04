//
//  EventCard.swift
//  Chevents
//
//  Created by Bid Sharma on 10/31/16.
//  Copyright © 2016 Bid Sharma. All rights reserved.
//

import UIKit
import Firebase

class EventCard: UITableViewCell {

    @IBOutlet weak var oraganizerName: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var joinEventButton: UIButton!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var peopleJoined: UILabel!
    @IBOutlet weak var eventEmail: UILabel!
    //Stars button
    
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star5: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star2: UIButton!
    
    var starButtonEnabled = false
    var cellIndexPath: IndexPath? = nil
    var eventMongoId: String? = nil
    //Delete button
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBAction func editAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure you want to edit this Event?", message: "", preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler:{
            (_) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"edit"), object: nil, userInfo: ["indexPath": self.cellIndexPath!])
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    //Stars actions
    @IBAction func star1Action(_ sender: UIButton) {
        if(self.starButtonEnabled){
            self.star1.setBackgroundImage(UIImage(named: "filledstar"), for: .normal)
            self.star2.setBackgroundImage(UIImage(named: "emptystar"), for: .normal)
            self.star3.setBackgroundImage(UIImage(named: "emptystar"), for: .normal)
            self.star4.setBackgroundImage(UIImage(named: "emptystar"), for: .normal)
            self.star5.setBackgroundImage(UIImage(named: "emptystar"), for: .normal)
            self.addRating(rating: 1)
        }

    }
    
    @IBAction func star2Action(_ sender: UIButton) {
        if(self.starButtonEnabled){
            self.star1.setBackgroundImage(UIImage(named: "filledstar"), for: .normal)
            self.star2.setBackgroundImage(UIImage(named: "filledstar"), for: .normal)
            self.star3.setBackgroundImage(UIImage(named: "emptystar"), for: .normal)
            self.star4.setBackgroundImage(UIImage(named: "emptystar"), for: .normal)
            self.star5.setBackgroundImage(UIImage(named: "emptystar"), for: .normal)
            self.addRating(rating: 2)
        }
        
    }
    
    @IBAction func star3Action(_ sender: UIButton) {
        if(self.starButtonEnabled){
            self.star1.setBackgroundImage(UIImage(named: "filledstar"), for: .normal)
            self.star2.setBackgroundImage(UIImage(named: "filledstar"), for: .normal)
            self.star3.setBackgroundImage(UIImage(named: "filledstar"), for: .normal)
            self.star4.setBackgroundImage(UIImage(named: "emptystar"), for: .normal)
            self.star5.setBackgroundImage(UIImage(named: "emptystar"), for: .normal)
            self.addRating(rating: 3)
        }

    }
    
    @IBAction func star4Action(_ sender: UIButton) {
        if(self.starButtonEnabled){
            self.star1.setBackgroundImage(UIImage(named: "filledstar"), for: .normal)
            self.star2.setBackgroundImage(UIImage(named: "filledstar"), for: .normal)
            self.star3.setBackgroundImage(UIImage(named: "filledstar"), for: .normal)
            self.star4.setBackgroundImage(UIImage(named: "filledstar"), for: .normal)
            self.star5.setBackgroundImage(UIImage(named: "emptystar"), for: .normal)
            self.addRating(rating: 4)
        }


    }
    
    @IBAction func start5Action(_ sender: UIButton) {
        if(self.starButtonEnabled){
            self.star1.setBackgroundImage(UIImage(named: "filledstar"), for: .normal)
            self.star2.setBackgroundImage(UIImage(named: "filledstar"), for: .normal)
            self.star3.setBackgroundImage(UIImage(named: "filledstar"), for: .normal)
            self.star4.setBackgroundImage(UIImage(named: "filledstar"), for: .normal)
            self.star5.setBackgroundImage(UIImage(named: "filledstar"), for: .normal)
            self.addRating(rating: 5)
        }
    }
    
    //delete action
    @IBAction func deleteAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure you want to delete this Event?", message: "", preferredStyle:.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler:{
            (_) in
            let deleteUrl: String = "\(self.eventMongoId!)/event/delete"
            RestApiManager.sharedInstance.doGetRequest(url: deleteUrl, onCompletion:{
                (json) in
                OperationQueue.main.addOperation {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:"remove"), object: nil, userInfo: ["indexPath": self.cellIndexPath!])
                }})
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func joinAction(_ sender: UIButton) {
        var title: String = ""
        var url: String = ""
        let uid : String = (FIRAuth.auth()?.currentUser?.uid)!
        let eid = self.eventMongoId!
        
        if(MySession.sharedInstance.currentIndex == 0){
            title = "Join the Event"
            url = "\(uid)/joinevent/\(eid)"
        }
        
        if(MySession.sharedInstance.currentIndex == 1){
            title = "Remove"
            url = "\(uid)/removeevent/\(eid)"
        }
        
        let alert = UIAlertController(title: "Please Confirm", message: "", preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: title, style: UIAlertActionStyle.default, handler:{
            (_) in
            RestApiManager.sharedInstance.doGetRequest(url: url, onCompletion: { (json) in
                OperationQueue.main.addOperation {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:"remove"), object: nil, userInfo: ["indexPath": self.cellIndexPath!])
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func returnSelfCell(tableView: UITableView, reuseId: String, indexPath: IndexPath, data: [String:AnyObject]) -> EventCard{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! EventCard
        
        cell.oraganizerName.text = data["org_name"] as! String?
        cell.eventEmail.text = data["org_email"] as! String?
        cell.eventName.text = data["name"] as! String?
        cell.eventDate.text = (data["date"] as! String?)!+" " + (data["time"] as! String?)!
        cell.eventLocation.text = data["location"] as! String?
        cell.peopleJoined.text = data["joined"] as! String?
    
        cell.cellIndexPath = indexPath
        cell.eventMongoId = data["_id"] as! String?
        self.clearAllStar(cell: cell)

        
        if(MySession.sharedInstance.isUserOrg){
            cell.joinEventButton.isHidden = true
            cell.deleteButton.isHidden = false
            cell.starButtonEnabled = false
            //Upcoming
            if(MySession.sharedInstance.currentIndex == 1){
                cell.editButton.isHidden = false
            }
            //Past
            if(MySession.sharedInstance.currentIndex == 2){
                cell.editButton.isHidden = true
                cell.deleteButton.isHidden = true
                let rating: Int = (data["rating"] as! Int?)!
                let starCellArray = [cell.star1, cell.star2, cell.star3, cell.star4, cell.star5]
                for index in 0..<rating{
                    starCellArray[index]?.setBackgroundImage(UIImage(named: "filledstar"), for: .normal)
                }
                
            }
            
        }else{
            cell.deleteButton.isHidden = true
            cell.editButton.isHidden = true
            cell.starButtonEnabled = false
            //For upcoming events title should be JOIN NOW
            if(MySession.sharedInstance.currentIndex == 0){
                cell.joinEventButton.setTitle("JOIN NOW!", for: .normal)
                cell.joinEventButton.isHidden = false
            }
            //Subscribed
            if(MySession.sharedInstance.currentIndex == 1){
                cell.joinEventButton.setTitle("REMOVE!", for: .normal)
                cell.joinEventButton.isHidden = false
            }
            //Past
            if(MySession.sharedInstance.currentIndex == 2){
                cell.starButtonEnabled = true
                cell.joinEventButton.isHidden = true
                let rating: Int = (data["rating"] as! Int?)!
                let starCellArray = [cell.star1, cell.star2, cell.star3, cell.star4, cell.star5]
                for index in 0..<rating{
                    starCellArray[index]?.setBackgroundImage(UIImage(named: "filledstar"), for: .normal)
                }
            }

        }
        return cell
    }
    
    func clearAllStar(cell: EventCard){
        cell.star1.setBackgroundImage(UIImage(named: "emptystar"), for: .normal)
        cell.star2.setBackgroundImage(UIImage(named: "emptystar"), for: .normal)
        cell.star3.setBackgroundImage(UIImage(named: "emptystar"), for: .normal)
        cell.star4.setBackgroundImage(UIImage(named: "emptystar"), for: .normal)
        cell.star5.setBackgroundImage(UIImage(named: "emptystar"), for: .normal)
    }
    
    func addRating(rating: Int){
        let uid : String = (FIRAuth.auth()?.currentUser?.uid)!
        let eid : String = self.eventMongoId!
        let url = "\(uid)/rateevent/\(eid)/\(rating)"
        RestApiManager.sharedInstance.doGetRequest(url: url, onCompletion:{
            (json) in
        })
    }
}
