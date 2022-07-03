//
//  File.swift
//  
//
//  Created by Pham Le Tuan Nam on 03/07/2022.
//

import Fluent
import Vapor

struct CVController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let cvs = routes.grouped("cvs")
        cvs.get(use: index)
        cvs.post(use: create)
        cvs.group(":cv_id") { cv in
            cv.delete(use: delete)
        }
    }
    
    func index(req: Request) async throws -> [CV] {
        try await CV.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> CV {
        let cv = try req.content.decode(CV.self)
        try await cv.save(on: req.db)
        return cv
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let cv = try await Todo.find(req.parameters.get("cv_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await cv.delete(on: req.db)
        return .noContent
    }
}
