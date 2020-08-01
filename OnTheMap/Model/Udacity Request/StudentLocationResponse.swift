//
//  StudentLocationResponse.swift
//  OnTheMap
//
//  Created by Adam Porter on 7/29/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct StudentLocationResponse: Codable {
    let results: [StudentLocation]?
}

struct StudentLocation: Codable {
    let createdAt: String?
    let firstName: String?
    let lastName: String?
    let longitude: Double?
    let latitude: Double?
    let mapString: String?
    let mediaURL: String?
    let uniqueKey: String?
    let objectId: String?
    let updatedAt: String?
}
