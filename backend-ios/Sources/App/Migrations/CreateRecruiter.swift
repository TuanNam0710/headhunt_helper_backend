//
//  File.swift
//  
//
//  Created by Phạm Lê Tuấn Nam on 05/07/2022.
//

import Fluent

struct CreateRecruiter: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("recruiters_db")
            .id()
            .field("name", .string)
            .field("email", .string)
            .field("password", .string)
            .field("active", .bool)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("recruiters_db").delete()
    }
}
