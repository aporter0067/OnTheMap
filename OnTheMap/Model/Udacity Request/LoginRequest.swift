//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Adam Porter on 7/22/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let username: String
    let password: String
}
