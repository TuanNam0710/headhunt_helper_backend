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
        let request = try req.content.decode(CreateJDRequest.self)
        let jd = JobDescription(idPosition: request.idPosition,
                                jobDescription: request.description,
                                noOfJobs: request.noOfJobs,
                                dueDate: request.dueDate)
        try await jd.save(on: req.db)
        return jd
    }
    
    func update(req: Request) async throws -> HTTPStatus {
        let request = try req.content.decode(UpdateJDRequest.self)
        if try await JobDescription.find(request.id, on: req.db) != nil {
            do {
                try await JobDescription.query(on: req.db)
                    .filter(\.$id == request.id)
                    .set(\.$dueDate, to: request.dueDate)
                    .set(\.$jobDescription, to: request.description)
                    .set(\.$noOfJobs, to: request.noOfJobs)
                    .update()
                return .noContent
            } catch {
                throw Abort(.badRequest)
            }
        } else {
            throw Abort(.notFound)
        }
    }
    
    func getDetail(req: Request) async throws -> JobDescriptionDetail {
        let id = try? req.content.decode([String: String].self)["id"]
        guard let idString = id, let id = Int(idString) else {
            throw Abort(.badRequest)
        }
        guard let jd = try await JobDescription.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        let namePosition = try await Position.find(jd.id, on: req.db)?.name
        let detail = JobDescriptionDetail(id: jd.id!,
                                                namePosition: namePosition ?? "",
                                                description: jd.jobDescription,
                                                noOfJobs: jd.noOfJobs,
                                                dueDate: jd.dueDate)
        return detail
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let jd = try await JobDescription.find(try req.content.decode([String: Int].self)["id"], on: req.db) else {
            throw Abort(.notFound)
        }
        try await jd.delete(on: req.db)
        return .noContent
    }
}
