//
//  TVShow.swift
//  ShowSearch
//
//  Created by Markim Shaw on 9/16/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import Foundation
import UIKit


struct TVShow {
    public let name:String
    public let poster_url:String
    public private(set) var poster:UIImage?
    let description:String?
    
    init(name:String, poster_url:String, description:String){
        self.name = name
        self.poster_url = poster_url
        self.description = description
    }
    
}
