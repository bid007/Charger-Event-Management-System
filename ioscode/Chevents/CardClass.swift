//
//  CardClass.swift
//  Chevents
//
//  Created by Bid Sharma on 11/1/16.
//  Copyright © 2016 Bid Sharma. All rights reserved.
//

import Foundation

class card{
    var nibName: String
    var cellRID: String
    var cellHeight: Float
    
    init(nibName:String, cellRID:String, cellHeight:Float = 100.0) {
        self.cellRID = cellRID
        self.nibName = nibName
        self.cellHeight = cellHeight
    }
}

