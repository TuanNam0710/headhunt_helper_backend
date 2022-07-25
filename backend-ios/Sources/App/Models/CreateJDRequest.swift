//
//  File.swift
//  
//
//  Created by Phạm Lê Tuấn Nam on 23/07/2022.
//

import Vapor

struct CreateJDRequest: Content {
    var idPosition: Int
    var description: String
    var noOfJobs: Int
    var dueDate: String
}

struct UpdateJDRequest: Content {
    var id: Int
    var idPosition: Int
    var description: String
    var noOfJobs: Int
    var dueDate: String
}
