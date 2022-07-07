//
//  File.swift
//  
//
//  Created by Phạm Lê Tuấn Nam on 05/07/2022.
//

import Fluent
import Vapor

final class Recruiter: Model, Content {
    static let schema = "recruiters_db"
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "active")
    var active: Bool
    
    init() { }
    
    init(id: Int? = nil, name: String, email: String, password: String, active: Bool) {
        self.id = id
        self.name = name
        self.email = email
        self.password = try! Bcrypt.hash(password)
        self.active = active
    }
    
    static func authenticate(email: String, password: String, database: Database) async throws -> Recruiter {
        var recruiter: Recruiter?
        
        let fetchedRecruiter = try await Recruiter.query(on: database)
            .filter(\.$email == email)
            .first()
        if let fetchedPassword = fetchedRecruiter?.password,
           fetchedPassword != "",
           (try? Bcrypt.verify(password, created: fetchedPassword)) == true {
            recruiter = fetchedRecruiter
        }
        if let recruiter = recruiter, !recruiter.active {
            return recruiter
        } else {
            throw Abort(.unauthorized)
        }
    }
    
    static func register(name: String, email: String, password: String, database: Database) async throws -> Recruiter {
        var newRecruiter: Recruiter?
        guard let password = try? Bcrypt.hash(password) else {
            throw Abort(.badRequest)
        }
        newRecruiter = Recruiter(name: name, email: email, password: password, active: false)
        
        if try await Recruiter.query(on: database)
            .filter(\.$email == email)
            .first() == nil {
            try await newRecruiter?.save(on: database)
            return newRecruiter!
        } else {
            throw Abort(.badRequest)
        }
    }
}
