//
//  ViewModel.swift
//  ShowsSearch
//
//  Created by Markim Shaw on 9/21/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import Foundation
import Alamofire

typealias Reload = Void

class ViewModel : ViewModelProtocol {
    public private(set) var data:[Container]?
    unowned var delegate:ViewModelDelegate
    
    
    init(delegate:ViewModelDelegate){
        self.data = [Container]()
        self.delegate = delegate
        //var h:Reload = delegate.reloadData()
        
        
    }
    
    func clearSearchData(){
        self.data = []
    }
    
    func addShow(show: TVShow) {
        let newShowContainer = Container.Data(value: show)
        self.data!.append(newShowContainer)
        self.delegate.reloadData()
    }
}

extension ViewModel {
    subscript(index:Int) -> Container {
        guard let data = self.data else { return Container.None }
        guard (index > -1 && index < data.count) else { return Container.None }
        
        return data[index]
    }
}
