import Fluent
import Vapor
import Foundation

func routes(_ app: Application) throws {
    app.get { req in
        return req.view.render("index", ["title": "Hello Vapor!"])
    }
    
    
    app.get("recruiters") { req async throws in
        try await Recruiter.query(on: req.db).all()
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
            var headers = HTTPHeaders()
            headers.add(name: .contentType, value: "text/html")
            return .init(headers: headers, body: .init(string: recruiter.email))
        } else {
            return .init(status: .unauthorized, headers: HTTPHeaders(), body: .empty)
        }
    }
    
    // Logout route
    app.post("logout") { req async throws -> HTTPStatus in
        if let id = Int(try req.content.decode([String: String].self).values.first ?? "") {
            do {
                try await Recruiter.query(on: req.db)
                    .set(\.$active, to: false)
                    .filter(\.$id == id)
                    .update()
                return .ok
            } catch {
                return .badRequest
            }
        } else {
            return .badRequest
        }
    }
    
    // Register route
    app.post("register") { req async throws -> HTTPStatus in
        let registerMessage = try req.content.decode(RegisterRequest.self)
        let name = registerMessage.name
        let email = registerMessage.email
        let password = registerMessage.password
        do {
            let _ = try await Recruiter.register(name: name, email: email, password: password, database: req.db)
            return .ok
        } catch {
            return .badRequest
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
    
    // Get all CVs route
    app.get("cv", "all") { req async throws in
        try await CV.query(on: req.db).all()
    }
}
