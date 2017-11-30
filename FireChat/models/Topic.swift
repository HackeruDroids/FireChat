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
    
    //computed property:
    //toJson -> Serialization!
    var json: Json{
        return [
            "topic": topic,
            "id": id,
            "dateModified" : dateModified.timeIntervalSince1970 * 1000
        ]
    }
    //De - serialization:
    init?(json: Json){
        guard let topic = json["topic"] as? String,
        let id = json["id"] as? String,
        let millis = json["dateModified"] as? TimeInterval
            
        else {
            return nil
        }
        let date = Date(timeIntervalSince1970: millis / 1000)
        self.init(topic: topic, id: id, date: date)
    }
    init(topic:String, id: String, date:Date ){
        self.topic = topic
        self.id = id
        self.dateModified = date
    }
}

typealias Json = [String : Any]
