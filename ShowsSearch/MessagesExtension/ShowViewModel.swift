//
//  MainViewModel.swift
//  ShowSearch
//
//  Created by Markim Shaw on 9/16/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import Foundation
import Alamofire

class ShowViewModel : ViewModelProtocol {
    unowned var delegate:ViewModelDelegate
    public private(set) var data:[TVShow]?
    
    init(delegate:ViewModelDelegate){
        data = [TVShow]()
        self.delegate = delegate
    }
    
    func clearSearchData(){
        self.data = []
    }
    
    func addShow(show:TVShow){
        self.data!.append(show)
        self.delegate.reloadData()
        //self.delegate?.collectionView?.reloadData()
    }
}
