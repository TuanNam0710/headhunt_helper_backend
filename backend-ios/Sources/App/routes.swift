import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return req.view.render("index", ["title": "Hello Vapor!"])
    }
    
    app.get("all") { req async throws in
        try await CV.query(on: req.db).all()
    }
    
    app.get("recruiters") { req async throws in
        try await Recruiters.query(on: req.db).all()
    }
    
    app.post("login") { req async throws -> HTTPStatus in
        let loginMessage = try req.content.decode(LoginRequest.self)
        let email = loginMessage.email
        let password = loginMessage.password
        return await validateLogin(email: email, password: password, database: req.db)
    }
    
    app.get("recruiters", ":email") { req -> EventLoopFuture<[Recruiters]> in
        let email = req.parameters.get("email")
        return Recruiters.query(on: req.db).filter(\.$email == "\(email ?? "")").all()
    }

    try app.register(collection: CVController())
}

func validateLogin(email: String, password: String, database: Database) async -> HTTPStatus {
    let dbPass = try? await Recruiters.query(on: database).filter(\.$email == email).first()?.password
    if dbPass != nil && dbPass == password {
        return .ok
    } else {
        return .unauthorized
    }
}
