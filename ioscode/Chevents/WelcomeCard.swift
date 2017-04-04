//
//  WelcomeCard.swift
//  Chevents
//
//  Created by Bid Sharma on 10/21/16.
//  Copyright © 2016 Bid Sharma. All rights reserved.
//

import UIKit

class WelcomeCard: UITableViewCell {

    @IBOutlet weak var greetingsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func returnSelfCell(tableView: UITableView, reuseId: String, indexPath: IndexPath, username: String) -> WelcomeCard {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! WelcomeCard
        cell.greetingsLabel.text = "Greetings, " + username
        return cell
    }
    
}
