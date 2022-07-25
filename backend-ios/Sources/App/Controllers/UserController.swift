//
//  File.swift
//  
//
//  Created by Phạm Lê Tuấn Nam on 21/07/2022.
//

import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.get(use: index)
        users.post(use: create)
        users.post(use: authenticate)
        users.group(":user_id") { recruiter in
            recruiter.delete(use: delete)
        }
    }
    
    func index(req: Request) async throws -> [User] {
        try await User.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> User {
        let user = try req.content.decode(RegisterRequest.self)
        var newUser: User?
        guard let password = try? Bcrypt.hash(user.password) else {
            throw Abort(.badRequest)
        }
        newUser = User(idDepartment: user.idDepartment,
                       name: user.name,
                       email: user.email,
                       password: password,
                       active: false,
                       role: user.role)
        if try await User.query(on: req.db)
            .filter(\.$email == user.email)
            .first() == nil {
            try await newUser?.save(on: req.db)
            return newUser!
        } else {
            throw Abort(.badRequest)
        }
    }
    
    func authenticate(req: Request) async throws -> User {
        let loginMessage = try req.content.decode(LoginRequest.self)
        var user: User?
        let fetchedUser = try await User.query(on: req.db)
            .filter(\.$email == loginMessage.email)
            .first()
        if let fetchedPassword = fetchedUser?.password,
           fetchedPassword != "",
           (try? Bcrypt.verify(loginMessage.password, created: fetchedPassword)) == true {
            user = fetchedUser
        }
        if let user = user, !user.active {
            try await User.query(on: req.db)
                .filter(\.$id == user.id!)
                .set(\.$active, to: true)
                .update()
            user.active = true
            return user
        } else {
            throw Abort(.unauthorized)
        }
    }
    
    func logout(req: Request) async throws -> HTTPStatus {
        let idString = try req.content.decode([String: String].self)["id"]
        if let id = Int(idString ?? "") {
            do {
                try await User.query(on: req.db)
                    .filter(\.$id == id)
                    .set(\.$active, to: false)
                    .update()
                return .ok
            } catch {
                throw Abort(.notFound)
            }
        } else {
            throw Abort(.badRequest)
        }
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await user.delete(on: req.db)
        return .noContent
    }
}

