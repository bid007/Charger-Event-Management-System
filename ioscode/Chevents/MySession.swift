//
//  MySession.swift
//  Chevents
//
//  Created by Bid Sharma on 10/30/16.
//  Copyright © 2016 Bid Sharma. All rights reserved.
//

import Foundation

class MySession {
    static let sharedInstance = MySession()
    var isUserOrg : Bool = true
    var menuItems = [String]()
    var currentIndex : Int = 0
    var id : String = ""
    var name: String = ""
}
