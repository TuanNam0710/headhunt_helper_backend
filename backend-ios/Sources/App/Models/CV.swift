//
//  File.swift
//  
//
//  Created by Pham Le Tuan Nam on 03/07/2022.
//

import Fluent
import Vapor

final class CV: Model, Content {
    
    static let schema = "cv_db"
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "gender")
    var gender: Int
    
    @Field(key: "position")
    var position: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "phone")
    var phone: String
    
    @ID(custom: "id_recruiter")
    var idRecruiter: Int?
    
    @Field(key: "status")
    var status: Int
    
    @ID(custom: "id_department")
    var idDepartment: Int?
    
    init() { }
    
    init(id: Int? = nil,
         name: String,
         gender: Int,
         position: String,
         email: String,
         phone: String,
         idRecruiter: Int? = nil,
         status: Int,
         idDepartment: Int? = nil) {
        self.id = id
        self.name = name
        self.gender = gender
        self.position = position
        self.email = email
        self.phone = phone
        self.idRecruiter = idRecruiter
        self.status = status
        self.idDepartment = idDepartment
    }
}
