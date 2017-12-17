//
//  NetworkModel.swift
//  HappayDemo
//
//  Created by Nancy Katal on 12/7/17.
//  Copyright © 2017 Demo. All rights reserved.
//

import UIKit

enum ErrorReason: Error {
    case internetNotReachable
    case couldNotSerializeData
    case couldNotParseJSON
    case noData
    case noSuccessStatusCode(statusCode: Int)
    case fromServer(NSError)
    case other(NSError?)
}

typealias JSONDictionary = [String:AnyObject]

typealias APIServiceCompletionCallback = ((NetworkRoot) -> ())
typealias APIServiceCompletionCallbackForNetworkDetail = ((NetworkDetailRoot) -> ())
typealias APIServiceFailureCallback = ((ErrorReason, NSError) -> ())

let BaseURL : String = "http://api.citybik.es/v2/"

struct APIKeys {
    
    struct ApiURL {
        static let getCityBikesList = "networks"
        static let getCityBikesDetail = "networks/"
    }
}
class NetworkManager: NSObject {
    
    static func getRequestInstance(urlString:String, jsonObj:Any?, requestType:String) -> URLRequest
    {
        let url = NSURL(string: urlString)! as URL
        
        var request = URLRequest.init(url: url)
        request.httpMethod = requestType
        
        if (jsonObj != nil)
        {
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj!)
            request.httpBody = jsonData
        }
        
        let tokenIdStr = UserDefaults.standard.value(forKey: "token")
        
        if let tokenIdStrTemp = tokenIdStr as! String?{
            request.setValue(tokenIdStrTemp, forHTTPHeaderField: "Authorization")
        }
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func getCityBikesList(failure: @escaping APIServiceFailureCallback, completion: @escaping APIServiceCompletionCallback) {
        
        let urlString = "\(BaseURL)\(APIKeys.ApiURL.getCityBikesList)"
        
        let urlRequest = NetworkManager.getRequestInstance(urlString: urlString, jsonObj: nil,requestType: "GET")
        
        let task = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if data != nil{
                let decoder = JSONDecoder()
                do {
                    let networkObj = try decoder.decode(NetworkRoot.self, from: data!)
                    completion(networkObj)
                } catch {
                    print("error trying to convert data to JSON")
                }
            } else {
                failure(ErrorReason.noData,error! as NSError)
            }
        }
        
        task.resume()
    }
    
    func getCityBikeDetails(_ networkId: String, failure: @escaping APIServiceFailureCallback, completion: @escaping APIServiceCompletionCallbackForNetworkDetail) {
        
        let urlString = "\(BaseURL)\(APIKeys.ApiURL.getCityBikesDetail)" + networkId
        
        let urlRequest = NetworkManager.getRequestInstance(urlString: urlString, jsonObj: nil,requestType: "GET")
        
        let task = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if data != nil{
                let decoder = JSONDecoder()
                do {
                    let networkDetailObj = try decoder.decode(NetworkDetailRoot.self, from: data!)
                    completion(networkDetailObj)
                } catch {
                    print("error trying to convert data to JSON")
                }
            } else {
                failure(ErrorReason.noData,error! as NSError)
            }
        }
        
        task.resume()
    }
}
