//
//  Container.swift
//  kk
//
//  Created by Markim Shaw on 9/20/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import Foundation

enum Container {
    case Data(value:TVShow)
    case None
    
    var value:TVShow {
        get {
            switch self {
            case .Data(let value):
                return value
            case .None:
                return TVShow(name: "", poster_url: "", description: "")
            }
        }
    }
}

