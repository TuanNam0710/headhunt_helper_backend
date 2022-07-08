import Fluent
import Vapor
import Foundation

func routes(_ app: Application) throws {
    // Home route
    app.get { req in
        return req.view.render("index", ["title": "Headhunt helper!"])
    }
    
    // Login route
    app.post("login") { req async throws -> Response in
        let loginMessage = try req.content.decode(LoginRequest.self)
        let email = loginMessage.email
        let password = loginMessage.password
        if let recruiter = try? await Recruiter.authenticate(email: email, password: password, database: req.db) {
            try await Recruiter.query(on: req.db).filter(\.$id == recruiter.id!)
                .set(\.$active, to: true)
                .update()
            return .init(status: .ok,
                         body: .init(string: recruiter.email))
        } else {
            return .init(status: .unauthorized,
                         body: .init(string: "Can't find user!"))
        }
    }
    
    // Register route
    app.post("register") { req async throws -> Response in
        let registerMessage = try req.content.decode(RegisterRequest.self)
        let name = registerMessage.name
        let email = registerMessage.email
        let password = registerMessage.password
        do {
            let _ = try await Recruiter.register(name: name, email: email, password: password, database: req.db)
            return .init(status: .ok,
                         body: .init(string: "Successfully registered!"))
        } catch {
            return .init(status: .badRequest,
                         body: .init(string: "Cannot register new user!"))
        }
    }
    
    // Protected group
    let protected = app.grouped(UserAuthenticator())
        .grouped(User.guardMiddleware())
    
    // Protected get user info route
    protected.get("getUserInfo", ":email") { req async throws -> Recruiter in
        try req.auth.require(User.self)
        let email = req.parameters.get("email")!
        return try await Recruiter.query(on: req.db).filter(\.$email == email)
            .first()!
    }
    
    // Protected get all CVs route
    protected.get("cv", "all") { req async throws in
        try await CV.query(on: req.db).all()
    }
    
    // Protected logout route
    protected.post("logout") { req async throws -> Response in
        if let id = Int(try req.content.decode([String: String].self).values.first ?? "") {
            do {
                try await Recruiter.query(on: req.db)
                    .set(\.$active, to: false)
                    .filter(\.$id == id)
                    .update()
                return .init(status: .ok,
                             body: .init(string: "Successfully logged out!"))
            } catch {
                return .init(status: .notFound,
                             body: .init(string: "Cannot find user with such id!"))
            }
        } else {
            return .init(status: .badRequest,
                         body: .init(string: "Error parsing request body!"))
        }
    }
    
    // Protected get all recruiters route
    protected.get("recruiters") { req async throws in
        try await Recruiter.query(on: req.db).all()
    }
}
