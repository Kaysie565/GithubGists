//
//  Gist.swift
//  GithubGists
//
//  Created by Polina Fiksson on 14/02/2018.
//  Copyright © 2018 PolinaFiksson. All rights reserved.
//

import Foundation

class Gist {
    //1. decide which bits of the JSON we want.
    var id: String?
    var description: String?
    var ownerLogin: String?
    var ownerAvatarURL: String?
    var url: String?
    
    required init() {
        
    }
    //Failable Initializer
    //We’ll want to create new gists from JSON so we can add an initializer for that class that takes in a JSON dictionary to create a gist object.
    required init?(json:[String: Any]) {
        guard let description = json["description"] as? String,
        let idValue = json["id"] as? String,
            let url = json["url"] as? String else {
                return nil
        }
        self.description = description
        self.id = idValue
        self.url = url
        
        if let ownerJson = json["owner"] as? [String:Any] {
            self.ownerLogin = ownerJson["login"] as? String
            self.ownerAvatarURL = ownerJson["avatar_url"] as? String
        }
    }
}
