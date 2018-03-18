//
//  WebserviceManager.swift
//  HomeDepot
//
//  Created by Madhu on 3/17/18.
//  Copyright © 2018 Madhu. All rights reserved.
//

import Foundation

struct WebserviceManager {
    
    static func initiateWebservice(url:URL,completionHandler:@escaping (Data)->Void){
        let task = URLSession.shared.dataTask(with:url) {
            (data, response, error) in
            // check for any errors
            if let error = error {
                print(error)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            completionHandler(responseData)
        }
        task.resume()
    }
}
