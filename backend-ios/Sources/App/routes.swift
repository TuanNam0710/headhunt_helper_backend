import Fluent
import Vapor
import Foundation

func routes(_ app: Application) throws {
    app.get { req in
        return req.view.render("index", ["title": "Hello Vapor!"])
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
    
    app.post("logout") { req async throws -> HTTPStatus in
        let uuid = try req.content.decode([String: String].self).values.first as String?
        do {
            try await Recruiters.query(on: req.db)
                .set(\.$active, to: false)
                .filter(\.$id == UUID(uuidString: uuid ?? "") ?? UUID())
                .update()
            return .ok
        } catch {
            return .badRequest
        }
    }
}

func validateLogin(email: String, password: String, database: Database) async -> HTTPStatus {
    let dbData = try? await Recruiters.query(on: database).filter(\.$email == email).first()
    if let dbPass = dbData?.password, dbPass == password,
       let dbActive = dbData?.active, !dbActive {
        try? await Recruiters.query(on: database)
            .set(\.$active, to: true)
            .filter(\.$email == email)
            .update()
        return .ok
    } else {
        return .unauthorized
    }
}
