//
//  GistRouter.swift
//  GithubGists
//
//  Created by Polina Fiksson on 13/02/2018.
//  Copyright © 2018 PolinaFiksson. All rights reserved.
//
/* Using a router with Alamofire is good practice since it helps keep our code organized. The router is responsible for creating the URL requests so that our API manager (or whatever makes the API calls) doesn’t need to do that along with all of the other responsibilities that it has.*/

import Foundation
import Alamofire

//1. declare a router. It’ll be an enum with a case for each type of call we want to make.
//Our router conforms to Alamofire’s URLRequestConvertible protocol, which combines critical parts of a network request
enum GistRouter: URLRequestConvertible {
    
    //1.Get the base URL
    static let baseURLString = "https://api.github.com/"
    //2.each type of call we want to make
    case getPublic()
    //protocols method
    //Within the asURLRequest() function we’ll need a few elements that we’ll combineto create the url request: the HTTP method, any parameters to pass, and the URL.
    func asURLRequest() throws -> URLRequest {
        //detemine the method type as a computed property
        var method: HTTPMethod {
            switch self {
            case .getPublic:
                return .get
            }
        }
        //build a url for each case(closure)
        let url: URL = {
            let relativePath: String
            switch self {
            case .getPublic():
                relativePath = "gists/public"
            }
            var url = URL(string: GistRouter.baseURLString)!
            url.appendPathComponent(relativePath)
            return url
        }()
        
        //build parameters(closure)
        let params: ([String: Any]?) = {
            switch self {
            case .getPublic:
                return nil
            }
        }()
        //create a URLRequest
        // The resulting URLRequest is used by Alamofire to contact the desired API endpoint.
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        //add a header
        //urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let encoding = JSONEncoding.default
        return try encoding.encode(urlRequest, with: params)
    }
}
