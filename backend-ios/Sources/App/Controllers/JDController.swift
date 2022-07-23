//
//  File.swift
//  
//
//  Created by Phạm Lê Tuấn Nam on 23/07/2022.
//

import Fluent
import Vapor

struct JDController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let jds = routes.grouped("jd")
        jds.get(use: index)
        jds.get(use: getDetail)
        jds.post(use: create)
        jds.post(use: update)
        jds.group(":id_jd") { jd in
            jd.delete(use: delete)
        }
    }
    
    func index(req: Request) async throws -> [JobDescription] {
        try await JobDescription.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> JobDescription {
        let jd = try req.content.decode(CreateJDRequest.self)
        try await jd.save(on: req.db)
        return jd
    }
    
    func update(req: Request) async throws -> JobDescription {
        
    }
    
    func getDetail(req: Request) async throws -> JobDescription {
        let id = try? req.content.decode([String: String].self)["id"]
        guard let idString = id, let id = Int(idString) else {
            throw Abort(.badRequest)
        }
        guard let jd = JobDescription.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        return jd
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let jd = JobDescription.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await jd.delete(on: req.db)
        return .noContent
    }
}
