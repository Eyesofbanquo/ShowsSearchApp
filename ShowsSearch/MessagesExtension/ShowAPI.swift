//
//  ShowAPI.swift
//  ShowSearch
//
//  Created by Markim Shaw on 9/17/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import Foundation
import Alamofire

class ViewModelWrapper {
    public private(set) weak var model:ViewModelProtocol?
    init(model:ViewModelProtocol){
        self.model = model
    }
    
}

struct ShowAPI {
    private let url:String
    private let params:Dictionary<String,String>
    private let model:ViewModelWrapper
    init(url:String, params:Dictionary<String,String>, delegate:ViewModelProtocol){
        self.url = url
        self.params = params
        self.model = ViewModelWrapper(model: delegate)
        
    }
    
    func request(){
        Alamofire.request(url, method: .get, parameters: self.params).responseJSON(completionHandler: {
            response in
            do {
                let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! Array<Dictionary<String, AnyObject>>
                for element in json {
                        var name:String
                        var poster_url:String?
                        var description:String
                        if element["show"] != nil {
                            name = element["show"]?["name"] as! String
                            if element["show"]!["image"] is NSNull {
                                poster_url = ""
                            } else {
                                poster_url = (element["show"]?["image"] as! Dictionary<String,AnyObject>)["original"] as? String
                            }
                            
                            description = element["show"]?["summary"] as! String
                        } else {
                            name = element["name"] as! String
                            if element["image"] is NSNull {
                                poster_url = ""
                            } else {
                                poster_url = element["image"]?["original"] as? String
                            }
                            
                            description = element["summary"] as! String
                        }
                        let newShow = TVShow(name: name, poster_url: poster_url!, description: description)
                        self.model.model?.addShow(show: newShow)
                    }
                    
                    
            } catch {
                
            }
            
        })
    }
    
    
}
