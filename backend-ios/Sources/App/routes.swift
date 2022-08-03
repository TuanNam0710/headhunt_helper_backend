import Fluent
import Vapor
import Foundation

func routes(_ app: Application) throws {
    // Home route
    app.get { req in
        return req.view.render("index", ["title": "Headhunt helper!"])
    }
    
    // Login route
    app.post("login") { req async throws -> User in
        do {
            let user = try await UserController().authenticate(req: req)
            return user
        } catch {
            throw Abort(.unauthorized)
        }
    }
    
    // Register route
    app.post("register") { req async throws -> Response in
        do {
            let _ = try await UserController().create(req: req)
            return .init(status: .ok,
                         body: .init(string: "{\"message\":\"Successfully registered!\"}"))
        } catch {
            return .init(status: .badRequest,
                         body: .init(string: "{\"message\":\"Cannot register new user!\"}"))
        }
    }
    
    // Protected group
    let protected = app.grouped(UserAuthenticator())
        .grouped(UserAuth.guardMiddleware())
    
    // Protected get user info route
    protected.get("getUserInfo") { req async throws -> User in
        try req.auth.require(UserAuth.self)
        let email = try req.content.decode([String: String].self)["email"]
        if let email = email {
            return try await User.query(on: req.db).filter(\.$email == email)
                .first()!
        } else {
            throw Abort(.badRequest)
        }
    }
    
    // Protected logout route
    protected.post("logout") { req async throws -> Response in
        try req.auth.require(UserAuth.self)
        let status = try await UserController().logout(req: req)
        return .init(status: status, body: .init(string: "{\"message\":\"Successfully logged out!\"}"))
    }
    
    // Protected get all users route
    protected.get("users") { req async throws -> [User] in
        try req.auth.require(UserAuth.self)
        return try await UserController().index(req: req)
    }
    
    // Protected get all CV of current recruiter route
    protected.get("cv", ":idRecruiter") { req async throws -> [CV] in
        if let idRecruiter = Int(req.parameters.get("idRecruiter")!) {
            return try await CV.query(on: req.db).filter(\.$idRecruiter == idRecruiter).all()
        }
        return []
    }
    
    // Protected get all CVs route
    protected.get("cv") { req async throws -> [CV] in
        try req.auth.require(UserAuth.self)
        return try await CVController().index(req: req)
    }
    
    // Protected get all Departments route
    protected.get("departments") { req async throws -> [Department] in
        try req.auth.require(UserAuth.self)
        return try await Department.query(on: req.db).all()
    }
    
    // Protected change detail route
    protected.post("cv", "changeDetail") { req async throws -> Response in
        try req.auth.require(UserAuth.self)
        do {
            try req.auth.require(UserAuth.self)
            try await CVController().changeDetail(req: req)
            return .init(status: .ok,
                         body: .init(string: "{\"message\":\"Update success!\"}"))
        } catch let error {
            throw error
        }
    }
    
    protected.post("cv", "detail") { req async throws -> CVDetail in
        try req.auth.require(UserAuth.self)
        do {
            return try await CVController().getDetail(req: req)
        } catch let error {
            throw error
        }
    }
    
    protected.get("jds") { req async throws -> [JobDescription] in
        try req.auth.require(UserAuth.self)
        do {
            return try await JDController().index(req: req)
        } catch {
            throw Abort(.badRequest)
        }
    }
    
    protected.post("jd", "create") { req async throws -> JobDescription in
        try req.auth.require(UserAuth.self)
        do {
            return try await JDController().create(req: req)
        } catch {
            throw Abort(.badRequest)
        }
    }
    
    protected.post("jd", "update") { req async throws -> HTTPStatus in
        try req.auth.require(UserAuth.self)
        do {
            return try await JDController().update(req: req)
        } catch {
            throw Abort(.badRequest)
        }
    }
    
    protected.post("jd", "detail") { req async throws -> JobDescriptionDetail in
        try req.auth.require(UserAuth.self)
        do {
            return try await JDController().getDetail(req: req)
        } catch {
            throw Abort(.notFound)
        }
    }
    
    protected.post("jd", "delete") { req async throws -> HTTPStatus in
        try req.auth.require(UserAuth.self)
        do {
            if try await JDController().delete(req: req) == .noContent {
                return .ok
            } else {
                return .badRequest
            }
        } catch {
            return .badRequest
        }
    }
    
    protected.get("depts") { req async throws -> [Department] in
        try req.auth.require(UserAuth.self)
        do {
            return try await DepartmentController().index(req: req)
        } catch {
            throw Abort(.badRequest)
        }
    }
    
    protected.post("positions") { req async throws -> [Position] in
        try req.auth.require(UserAuth.self)
        do {
            return try await DepartmentController().getPositions(req: req)
        } catch {
            throw Abort(.badRequest)
        }
    }
}
