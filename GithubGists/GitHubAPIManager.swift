//
//  GitHubAPIManager.swift
//  GithubGists

/*This class with be responsible for our API interactions.
 It’ll help us keep our code organized so our view controllers don’t end up as monstrously huge files.*/

//  Created by Polina Fiksson on 13/02/2018.
//  Copyright © 2018 PolinaFiksson. All rights reserved.
//

import Foundation
import Alamofire

enum GitHubAPIManagerError: Error {
    case network(error: Error)
    case apiProvidedError(reason: String)
    case authCouldNot(reason: String)
    case authLost(reason: String)
    case objectSerialization(reason: String)
}

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
    //Set up a function that GETs the public gists, parses them into an array and returns them
    
    /* API is an asynchronous process:
     we fire off the request and get notified when it’s done. We can set up the code with a completion
     handler. That lets us add a chunk of code to be called when the method is done. Our completion
     handler needs to handle two possibilities: we might return an array of Gists and we might return
     an error.*/
    func fetchPublicGists(completionHandler: @escaping (Result<[Gist]>) -> Void) {
        Alamofire.request(GistRouter.getPublic()).responseJSON {
            response in
            let result = self.gistArrayFromResponse(response: response)
            completionHandler(result)
        }
        
    }
    
    
    //MARK: extract an array of gists from the received response
    /* Result is a special type that Alamofire has created to allow us to return either a .success case (in this case, with the array of gists: [Gist]) or a .failure case with an error.*/
    private func gistArrayFromResponse(response: DataResponse<Any>) -> Result<[Gist]> {
        guard response.result.error == nil else {
            print(response.result.error!)
            //if Alamofire gives us an error:
            return .failure(GitHubAPIManagerError.network(error: response.result.error!))
        }
        //make sure we got JSON and it's an array
        guard let jsonArray = response.result.value as? [[String:Any]] else {
            //can’t get the JSON array out of the response
            return .failure(GitHubAPIManagerError.objectSerialization(reason:
                "Did not get JSON dictionary in response"))
        }
        //check for "message" errors in the JSON because this API does that
        if let jsonDictionary = response.result.value as? [String:Any],
            let errorMessage = jsonDictionary["message"] as? String {
            
            return .failure(GitHubAPIManagerError.apiProvidedError(reason: errorMessage))
        }
        
        //turn JSON data into gists
        var gists = [Gist]()
        for item in jsonArray {
            if let gist = Gist(json: item) {
                gists.append(gist)
            }
        }
        return .success(gists)
        
    }
}
