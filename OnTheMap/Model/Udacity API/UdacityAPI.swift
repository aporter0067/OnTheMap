//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Adam Porter on 7/20/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

class UdacityAPI {
    
    struct Auth {
        static var userId = ""
    }
    
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com"
        
        case createSessionId
        case userInfo
        
        var stringValue: String {
            switch self {
            case .createSessionId: return Endpoints.base + "/v1/session"
            case .userInfo: return Endpoints.base + "/v1/users/\(Auth.userId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
  
    //MARK: POST Requests
    class func createSessionId(completion: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: Endpoints.createSessionId.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
              return
          }
            
        let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    
    //MARK: GET Requests
    class func userInfo(completion: @escaping (Bool, Error?) ->Void) {
        
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/3903878747")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error...
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
        
        
        
    }
    
    //MARK: DELETE Request
    class func deleteUserInfo(completion: (Bool, Error?) ->Void) {
       
        var request = URLRequest(url: Endpoints.createSessionId.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
    
}
