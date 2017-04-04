//
//  CreateEventCell.swift
//  Chevents
//
//  Created by Bid Sharma on 11/2/16.
//  Copyright © 2016 Bid Sharma. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class CreateEventCell: UITableViewCell {

    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventDescription: UITextField!
    @IBOutlet weak var eventLocation: UITextField!
    @IBOutlet weak var eventMonth: UITextField!
    @IBOutlet weak var eventDay: UITextField!
    @IBOutlet weak var eventYear: UITextField!
    @IBOutlet weak var eventTime: UITextField!
    @IBOutlet weak var amOrPm: UISegmentedControl!
    var mongoId: String? = nil
    
    @IBAction func submitEvent(_ sender: Any) {
    
        let name : String = self.eventName.text!
        let description : String = self.eventDescription.text!
        let location : String  = self.eventLocation.text!
        let month : String = self.eventMonth.text!
        let day : String = self.eventDay.text!
        let year : String = self.eventYear.text!
        let time : String = self.eventTime.text!
        let amOrPm : String = (self.amOrPm.selectedSegmentIndex == 0) ? "AM" : "PM"
        let dateString = "\(month)/\(day)/\(year)"
        let timeString = "\(time)\(amOrPm)"
        let hhmm = time.components(separatedBy: ":")
        let hour = String((Int(hhmm[0])! + 12)%24)
        let dateStringComp = dateString + " " + hour + ":" + hhmm[1]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        let eventDate = dateFormatter.date(from: dateStringComp)
        
        if(eventDate != nil && eventDate?.compare(NSDate() as Date).rawValue == 1){
            var eventData : [String : String] = ["name" : name, "description" : description,
                                                 "location" : location, "date" : dateString,
                                                 "time" : timeString]
            var successMsg = "Event Added"
            if self.mongoId != nil{
                eventData["_id"] = self.mongoId
                successMsg = "Event Updated"
                self.mongoId = nil
            }
            
            let uid : String = (FIRAuth.auth()?.currentUser?.uid)!
            let url = "\(uid)/event/create"
            RestApiManager.sharedInstance.doPostRequest(data: eventData, requestUrl: url, onCompletion: {
                (json) in
                let status = json["status"].int
                OperationQueue.main.addOperation {
                    if(status == 1){
                        self.showAlert(mainTitle: "Success", message: successMsg, actionTitle: "Ok")
                        self.resetFields()
                    }else{
                        self.showAlert(mainTitle: "Error", message: "Please try again.", actionTitle: "Ok")
                    }
                }
            })
        }else{
            self.showAlert(mainTitle: "Error", message: "Past date given", actionTitle: "Ok")
    
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func resetFields(){
        self.eventName.text = ""
        self.eventDescription.text = ""
        self.eventLocation.text = ""
        self.eventMonth.text = ""
        self.eventDay.text = ""
        self.eventYear.text = ""
        self.eventTime.text = ""
    }
    
    func returnSelfCell(tableView: UITableView, reuseId: String, indexPath: IndexPath, data: [String: AnyObject]) -> CreateEventCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! CreateEventCell
        if data["_id"] != nil{
            cell.mongoId = data["_id"] as! String?
            cell.eventLocation.text = data["location"] as! String?
            cell.eventName.text = data["name"] as! String?
            cell.eventDescription.text = data["description"] as! String?
            let date = data["date"] as! String?
            let time = data["time"] as! String?
            let dateArray = date?.components(separatedBy: "/")
            cell.eventMonth.text = dateArray?[0]
            cell.eventDay.text = dateArray?[1]
            cell.eventYear.text = dateArray?[2]
            
            var amOrPm = ""
            if time?.range(of: "AM") != nil {
                cell.amOrPm.selectedSegmentIndex = 0
                amOrPm = (time?.components(separatedBy: "AM")[0])!
            }else{
               cell.amOrPm.selectedSegmentIndex = 1
                amOrPm = (time?.components(separatedBy: "PM")[0])!
            }
            cell.eventTime.text = amOrPm
        }
        return cell
    }
    
    func showAlert(mainTitle:String, message: String, actionTitle: String){
        let alert = UIAlertController(title: mainTitle, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)

    }
}
