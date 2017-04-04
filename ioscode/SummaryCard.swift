//
//  SummaryCard.swift
//  Chevents
//
//  Created by Bid Sharma on 11/10/16.
//  Copyright © 2016 Bid Sharma. All rights reserved.
//

import UIKit

class SummaryCard: UITableViewCell {

    @IBOutlet weak var numberOfEvents: UILabel!
    @IBOutlet weak var attendance: UILabel!
    @IBOutlet weak var averageRating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func returnSelfCell(tableView: UITableView, reuseId: String, indexPath: IndexPath, data: [String:AnyObject]) -> SummaryCard{
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! SummaryCard
        cell.numberOfEvents.text = data["events_count"] as! String?
        cell.averageRating.text =  data["avg_rating"] as! String?
        cell.attendance.text = data["attendance"] as! String?
        return cell
    }

    
}
