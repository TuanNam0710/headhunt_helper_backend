//
//  File.swift
//  
//
//  Created by Phạm Lê Tuấn Nam on 05/07/2022.
//

import Fluent
import Vapor

final class Recruiters: Model, Content {
    static let schema = "recruiters_db"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "active")
    var active: Bool
    
    init() { }
    
    init(id: UUID? = nil, name: String, email: String, password: String, active: Bool) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.active = active
    }
}
