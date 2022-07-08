//
//  File.swift
//  
//
//  Created by Phạm Lê Tuấn Nam on 07/07/2022.
//

import Vapor

struct RegisterRequest: Content {
    var name: String
    var email: String
    var password: String
}
