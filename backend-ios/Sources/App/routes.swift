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
                         body: .init(string: "{\"message\":\"\(recruiter.email)\"}"))
        } else {
            return .init(status: .unauthorized,
                         body: .init(string: "{\"message\":\"Can't find user!\"}"))
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
                         body: .init(string: "{\"message\":\"Successfully registered!\"}"))
        } catch {
            return .init(status: .badRequest,
                         body: .init(string: "{\"message\":\"Cannot register new user!\"}"))
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
    
    // Protected logout route
    protected.post("logout") { req async throws -> Response in
        if let id = Int(try req.content.decode([String: String].self).values.first ?? "") {
            do {
                try await Recruiter.query(on: req.db)
                    .set(\.$active, to: false)
                    .filter(\.$id == id)
                    .update()
                return .init(status: .ok,
                             body: .init(string: "{\"message\":\"Successfully logged out!\"}"))
            } catch {
                return .init(status: .notFound,
                             body: .init(string: "{\"message\":\"Cannot find user with such id!\"}"))
            }
        } else {
            return .init(status: .badRequest,
                         body: .init(string: "{\"message\":\"Error parsing request body!\"}"))
        }
    }
    
    // Protected get all recruiters route
    protected.get("recruiters") { req async throws in
        try await Recruiter.query(on: req.db).all()
    }
    
    // Protected get all CV of current recruiter route
    protected.get("cv", ":idRecruiter") { req async throws -> [CV] in
        if let idRecruiter = Int(req.parameters.get("idRecruiter")!) {
            return try await CV.query(on: req.db).filter(\.$idRecruiter == idRecruiter).all()
        }
        return []
    }
    
    // Protected get all CVs route
    protected.get("cv", "all") { req async throws in
        try await CV.query(on: req.db).all()
    }
    
    // Protected get all Departments route
    protected.get("departments") { req async throws in
        try await Department.query(on: req.db).all()
    }
    
    // Protected assign to department route
    protected.post("cv", ":idCV", "assignToDept", ":idDepartment") { req async throws -> Response in
        if let idDepartment = Int(req.parameters.get("idDepartment")!),
            let idCV = Int(req.parameters.get("idCV")!) {
            do {
                try await CV.query(on: req.db).filter(\.$id == idCV)
                    .set(\.$idDepartment, to: idDepartment)
                    .update()
                return .init(status: .ok,
                             body: .init(string: "{\"message\":\"Update success!\"}"))
            } catch {
                return .init(status: .badRequest,
                             body: .init(string: "{\"message\":\"Cannot update!\"}"))
            }
        } else {
            return .init(status: .badRequest,
                         body: .init(string: "{\"message\":\"Cannot parse id from request!\"}"))
        }
    }
    
    // Protected assign to recuiter route
    protected.post("cv", ":idCV", "assignToRecruiter", ":idRecruiter") { req async throws -> Response in
        if let idRecruiter = Int(req.parameters.get("idRecruiter")!),
            let idCV = Int(req.parameters.get("idCV")!) {
            do {
                try await CV.query(on: req.db).filter(\.$id == idCV)
                    .set(\.$idRecruiter, to: idRecruiter)
                    .update()
                return .init(status: .ok,
                             body: .init(string: "{\"message\":\"Update success!\"}"))
            } catch {
                return .init(status: .badRequest,
                             body: .init(string: "{\"message\":\"Cannot update!\"}"))
            }
        } else {
            return .init(status: .badRequest,
                         body: .init(string: "{\"message\":\"Cannot parse id from request!\"}"))
        }
    }
    
    // Protected update cv status route
    protected.post("cv", ":idCV", "updateCVStatus", ":status") { req async throws -> Response in
        if let status = Int(req.parameters.get("status")!),
            let idCV = Int(req.parameters.get("idCV")!) {
            do {
                try await CV.query(on: req.db).filter(\.$id == idCV)
                    .set(\.$status, to: status)
                    .update()
                return .init(status: .ok,
                             body: .init(string: "{\"message\":\"Update success!\"}"))
            } catch {
                return .init(status: .badRequest,
                             body: .init(string: "{\"message\":\"Cannot update!\"}"))
            }
        } else {
            return .init(status: .badRequest,
                         body: .init(string: "{\"message\":\"Cannot parse id from request!\"}"))
        }
    }
    
    // Protected get cv basic info
    protected.get("cv", "basicInfo", ":idCV") { req async throws -> [CV] in
        let idCV = Int(req.parameters.get("idCV")!)!
        return try await CV.query(on: req.db).filter(\.$id == idCV).all()
    }

    // Protected get cv skills
    protected.get("cv", "skills", ":idCV") { req async throws -> [Skills] in
        let idCV = Int(req.parameters.get("idCV")!)!
        return try await Skills.query(on: req.db).filter(\.$idCV == idCV).all()
    }

    // Protected get cv work experience
    protected.get("cv", "workExperience", ":idCV") { req async throws -> [WorkExperience] in
        let idCV = Int(req.parameters.get("idCV")!)!
        return try await WorkExperience.query(on: req.db).filter(\.$idCV == idCV).all()
    }

    // Protected get cv additional info
    protected.get("cv", "additionalInfo", ":idCV") { req async throws -> [AdditionalInfo] in
        let idCV = Int(req.parameters.get("idCV")!)!
        return try await AdditionalInfo.query(on: req.db).filter(\.$idCV == idCV).all()
    }
}
