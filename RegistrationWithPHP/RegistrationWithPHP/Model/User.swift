//
//  User.swift
//  RegistrationWithPHP
//
//  Created by Nelson Gonzalez on 9/22/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation

struct User: Codable {
    let status: String
    let message: String
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    let birthday: String
    let gender: String
    let cover: String?
    let ava: String?
    let bio: String?
    let ip: String?
    
}
