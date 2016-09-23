//
//  ShowControllerDelegate.swift
//  ShowsSearch
//
//  Created by Markim Shaw on 9/21/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import Foundation
import UIKit

protocol ShowControllerDelegate: class {
    func sendTVInformation(show:Container, posterImage:UIImage?)
    func toCompactPresentationStyle()
    func toExtendedPresentationStyle()
    func dismiss()
}

extension ShowControllerDelegate {
    var backFromController:Bool {
        get {
            return true
        }
    }
}
