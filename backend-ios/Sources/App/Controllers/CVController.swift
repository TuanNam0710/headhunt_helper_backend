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
    
    func changeDetail(req: Request) async throws {
        let message = try req.content.decode(ChangeDetailRequest.self)
        let id = message.id
        let idDept = message.idDept
        let idRecruiter = message.idRecruiter
        let status = message.status
        do {
            if let idRecruiter = idRecruiter {
                try await CV.query(on: req.db)
                    .filter(\.$id == id)
                    .set(\.$idRecruiter, to: idRecruiter)
                    .update()
            }
            if let idDept = idDept {
                try await CV.query(on: req.db)
                    .filter(\.$id == id)
                    .set(\.$idDepartment, to: idDept)
                    .update()
            }
            try await CV.query(on: req.db)
                .filter(\.$id == id)
                .set(\.$status, to: status)
                .update()
        } catch {
            throw Abort(.badRequest)
        }
    }
    
    func getDetail(req: Request) async throws -> CVDetail {
        let cvDetail: CVDetail?
        let idString = try? req.content.decode([String: String].self)["id"]
        if let id = Int(idString ?? "") {
            let basicInfo = try await CV.query(on: req.db).filter(\.$id == id).first()
            let skills = try await Skills.query(on: req.db).filter(\.$idCV == id).all()
            let workExperience = try await WorkExperience.query(on: req.db).filter(\.$idCV == id).all()
            let additionalInfo = try await AdditionalInfo.query(on: req.db).filter(\.$idCV == id).all()
            cvDetail = CVDetail(basicInfo: basicInfo!,
                                skill: skills,
                                workExperience: workExperience,
                                additionalInfo: additionalInfo)
            if let cvDetail = cvDetail {
                return cvDetail
            } else {
                throw Abort(.badRequest)
            }
        } else {
            throw Abort(.badRequest)
        }
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let cv = try await CV.find(req.parameters.get("cv_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await cv.delete(on: req.db)
        return .noContent
    }
}
