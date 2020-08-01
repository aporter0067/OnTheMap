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
        case getUserInfo
        case getStudentLocation
        
        var stringValue: String {
            switch self {
            
            case .login:
                return Endpoints.udacitySessionURL
            case .logout:
                return Endpoints.udacitySessionURL
            case .getUserInfo:
                return Endpoints.udacityUserInfoURL + "\(Auth.userId)"
            case .getStudentLocation:
                return Endpoints.studentLocationURL + "?order=-updatedAt"
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
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
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
    
    
    //MARK: GET Student Location
    class func getStudentLocation(completion: @escaping ([StudentLocation]?, Error?) ->Void?) {
        
        
        var request = URLRequest(url: Endpoints.getStudentLocation.url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          
            if error != nil { // Handle error...
              return
          }
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            
          print(String(data: data, encoding: .utf8)!)
            
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(StudentLocationResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject.results, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    //MARK: POST Student Location
    class func postStudentLocation(completion: @escaping (Bool, Error?) ->Void) {
        
        var request = URLRequest(url: Endpoints.getStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
    
    //MARK: User Info
    class func getUserInfo(student: UserInfo, completion: @escaping (Bool, Error?) ->Void) {
        
        let request = URLRequest(url: Endpoints.getUserInfo.url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          
            if error != nil { // Handle error...
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
                let responseObject = try decoder.decode(UserInfo.self, from: newData)
                firstName = responseObject.firstName
                lastName = responseObject.lastName
                print(responseObject)
                DispatchQueue.main.async {
                    completion(true, error)
                }
                
            } catch {
                completion(false, error)
            }
            
        }
        task.resume()
        
        
        
    }
    
    //MARK: Update Student Location
    
    class func updateStudentLocation(completion: @escaping (Bool, Error?) ->Void) {
        
        let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation/8ZExGR5uX8"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody =
            "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
    
    
    
}
