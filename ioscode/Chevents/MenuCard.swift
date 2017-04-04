//
//  MenuCard.swift
//  
//
//  Created by Bid Sharma on 10/30/16.
//
//

import UIKit

class MenuCard: UITableViewCell {
    @IBOutlet weak var menuLabel: UILabel!
    
    @IBAction func NextButton(_ sender: Any) {
        let index = MySession.sharedInstance.currentIndex
        let choice = MySession.sharedInstance.menuItems
        MySession.sharedInstance.currentIndex = (index + 1) % choice.count
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    @IBAction func PrevButton(_ sender: Any) {
        let index = MySession.sharedInstance.currentIndex
        let choice = MySession.sharedInstance.menuItems
        MySession.sharedInstance.currentIndex = (index == 0) ? (choice.count - 1) : ((index - 1) % choice.count)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func returnSelfCell(tableView: UITableView, reuseId: String, indexPath: IndexPath) -> MenuCard {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! MenuCard
        let index = MySession.sharedInstance.currentIndex
        let choice = MySession.sharedInstance.menuItems
        cell.menuLabel.text = choice[index]
        return cell
    }

}
