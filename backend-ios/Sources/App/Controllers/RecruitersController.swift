//
//  File.swift
//  
//
//  Created by Phạm Lê Tuấn Nam on 05/07/2022.
//

import Fluent
import Vapor

struct RecruitersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let recruiters = routes.grouped("recruiters")
        recruiters.get(use: index)
        recruiters.post(use: create)
        recruiters.group(":recruiters_id") { recruiter in
            recruiter.delete(use: delete)
        }
    }
    
    func index(req: Request) async throws -> [Recruiters] {
        try await Recruiters.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> Recruiters {
        let recruiter = try req.content.decode(Recruiters.self)
        try await recruiter.save(on: req.db)
        return recruiter
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let recruiter = try await Recruiters.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await recruiter.delete(on: req.db)
        return .noContent
    }
}
