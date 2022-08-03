//
//  File.swift
//  
//
//  Created by Phạm Lê Tuấn Nam on 25/07/2022.
//

import Fluent
import Vapor

struct DepartmentController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let depts = routes.grouped("depts")
        depts.get(use: index)
        depts.get(use: getPositions)
    }
    
    func index(req: Request) async throws -> [Department] {
        try await Department.query(on: req.db).all()
    }
    
    func getPositions(req: Request) async throws -> [Position] {
        guard let deptId = Int(try req.content.decode([String: String].self)["id"] ?? "") else {
            throw Abort(.notFound)
        }
        if deptId == 6 {
            let positionList = try await Position.query(on: req.db)
                .all()
            return positionList
        } else {
            let positionList = try await Position.query(on: req.db)
                .filter(\.$idDepartment == deptId)
                .all()
            return positionList
        }
    }
}
