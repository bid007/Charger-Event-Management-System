//
//  ApiCalls.swift
//  Chevents
//
//  Created by Bid Sharma on 10/9/16.
//  Copyright © 2016 Bid Sharma. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    
    let baseURL = "http://localhost:8080/"
    
    func getUser(uid : String, onCompletion: @escaping (JSON) -> Void) {
        let route = baseURL + "user/" + uid
        makeHTTPGetRequest(path: route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    func createUser(userInfo: [String: String], url:String, onCompletion:@escaping (JSON) -> Void){
        let route = baseURL + url
        makeHTTPPostRequest(path: route, body: userInfo, onCompletion: {
            json, err in
            onCompletion(json as JSON)
        })
    }
    
    func doPostRequest(data : [String:String], requestUrl:String, onCompletion:@escaping(JSON)-> Void) {
        let route = baseURL + requestUrl
        makeHTTPPostRequest(path:route, body:data, onCompletion: {
            json, err in
            onCompletion(json as JSON)
        })
    }
    
    func doGetRequest(url: String,  onCompletion: @escaping (JSON) -> Void) {
        let route = baseURL + url
        makeHTTPGetRequest(path: route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }


    // MARK: Perform a GET Request
    private func makeHTTPGetRequest(path: String, onCompletion: @escaping ServiceResponse) {
        let request = NSMutableURLRequest(url: NSURL(string: path)! as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let jsonData = data {
                let json:JSON = JSON(data: jsonData)
                onCompletion(json, error as NSError?)
            } else {
                onCompletion(JSON.null, error as NSError?)
            }
        })
        task.resume()
    }
    
    
    // MARK: Perform a POST Request
    private func makeHTTPPostRequest(path: String, body: [String: String], onCompletion: @escaping ServiceResponse) {
        let request = NSMutableURLRequest(url: NSURL(string: path)! as URL)
        
        // Set the method to POST
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        // Set the POST body for the request
        request.httpBody = postParamBuilder(data: body).data(using: String.Encoding.utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let jsonData = data {
                let json:JSON = JSON(data: jsonData)
                onCompletion(json, nil)
            } else {
                onCompletion(JSON.null, error as NSError?)
            }
        })
        task.resume()
    }
    
    private func postParamBuilder(data:[String: String]) -> String{
        var result: String = ""
        for(key, value) in data{
            result = result + "\(key)=\(value)&"
        }
        return result
    }
    
}
