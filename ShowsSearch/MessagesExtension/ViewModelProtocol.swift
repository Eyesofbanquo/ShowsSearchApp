//
//  ViewModelProtocol.swift
//  ShowSearch
//
//  Created by Markim Shaw on 9/17/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import Foundation

protocol ViewModelProtocol : class{
    var delegate:ViewModelDelegate { get set }
    func addShow(show:TVShow)
}
