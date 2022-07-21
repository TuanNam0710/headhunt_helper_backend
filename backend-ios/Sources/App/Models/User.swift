//
//  File.swift
//  
//
//  Created by Phạm Lê Tuấn Nam on 21/07/2022.
//

import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "user_db"
    
    @ID(custom: "id")
    var id: Int?
    
    @ID(custom: "id_department")
    var idDepartment: Int?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "active")
    var active: Bool
    
    @Field(key: "role")
    var role: String
    
    init() { }
    
    init(id: Int? = nil, idDepartment: Int? = nil, name: String, email: String, password: String, active: Bool, role: String) {
        self.id = id
        self.idDepartment = idDepartment
        self.name = name
        self.email = email
        self.password = password
        self.active = active
        self.role = role
    }
}
