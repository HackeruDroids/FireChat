//
//  Topic.swift
//  FireChat
//
//  Created by hackeru on 12 Kislev 5778.
//  Copyright © 5778 hackeru. All rights reserved.
//

import UIKit

struct Topic {
    var topic:String
    let id: String //id?!
    var dateModified: Date
    var owner: String
    
    //computed property:
    //toJson -> Serialization!
    var json: Json{
        return [
            "topic": topic,
            "id": id,
            "owner": owner,
            "dateModified" : dateModified.timeIntervalSince1970 * 1000
        ]
    }
    //De - serialization:
    init?(json: Json){
        guard let topic = json["topic"] as? String,
            let id = json["id"] as? String,
            let owner = json["owner"] as? String,
            let millis = json["dateModified"] as? TimeInterval
            
            else {
                return nil
        }
        let date = Date(timeIntervalSince1970: millis / 1000)
        
        self.init(topic: topic, id: id, owner:owner, date: date)
    }
    init(topic:String, id: String, owner:String, date:Date = Date() ){
        self.topic = topic
        self.id = id
        self.dateModified = date
        self.owner = owner
    }
}

typealias Json = [String : Any]
