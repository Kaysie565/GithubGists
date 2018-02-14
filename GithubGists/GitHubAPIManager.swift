//
//  GitHubAPIManager.swift
//  GithubGists

/*This class with be responsible for our API interactions.
 It’ll help us keep our code organized so our view controllers don’t end up as
 monstrously huge files.*/

//  Created by Polina Fiksson on 13/02/2018.
//  Copyright © 2018 PolinaFiksson. All rights reserved.
//

import Foundation
import Alamofire

class GitHubAPIManager {
    //1.we only need a single app manager in our app
    static let sharedInstance = GitHubAPIManager()
    
    //MARK: setting up the API call to get the public gists
    func printPublicGists()-> Void {
        Alamofire.request(GistRouter.getPublic()).responseString {
            response in
            if let receivedString = response.result.value {
                print(receivedString)
            }
        }
    }
}
