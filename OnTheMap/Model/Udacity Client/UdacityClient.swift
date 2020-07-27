//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Adam Porter on 7/20/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

class UdacityClient {
    
    static var accountKey: String = ""
    static var objectId: String = ""
    static var uniqueKey: String = ""
    static var firstName: String = ""
    static var lastName: String = ""
    static var mapString: String = ""
    static var mediaURL: String = ""
    static var latitude: Double = 0.0
    static var longitude: Double = 0.0
    static var createdAt: String = ""
    static var updatedAt: String = ""
    
    struct Auth {
        static var userId = ""
    }
    
    enum Endpoints {
        
        static let udacitySessionURL = "https://onthemap-api.udacity.com/v1/session"
        static let udacityUserInfoURL = "https://onthemap-api.udacity.com/v1/users/"
        static let studentLocationURL = "https://onthemap-api.udacity.com/v1/StudentLocation"
        
        case login
        case logout
        
        
        var stringValue: String {
            switch self {
            
            case .login:
                return Endpoints.udacitySessionURL
            case .logout:
                return Endpoints.udacitySessionURL
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
  
    //MARK: Login
    class func createSessionId(_ email: String,_ password: String, completion: @escaping (Bool, Error?) ->()) {
        
        var request = URLRequest(url: Endpoints.login.url)
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
            
            guard let data = data else {
                completion(false, error)
                return
            }
           
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(LoginResponse.self, from: newData)
                let accountId = responseObject.account.key
                self.accountKey = accountId!
                DispatchQueue.main.async {
                    completion(true, error)
                }
            } catch {
                completion(false, error)
            }
    
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
    
    //MARK: Logout
    class func deleteUserInfo(completion: (Bool, Error?) ->Void) {
       
        var request = URLRequest(url: Endpoints.logout.url)
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
