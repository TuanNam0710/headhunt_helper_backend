//
//  File.swift
//  
//
//  Created by Phạm Lê Tuấn Nam on 05/07/2022.
//

import Vapor

struct LoginRequest: Content {
    var email: String
    var password: String
}
