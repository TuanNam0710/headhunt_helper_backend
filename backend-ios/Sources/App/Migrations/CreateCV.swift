//
//  File.swift
//  
//
//  Created by Pham Le Tuan Nam on 03/07/2022.
//

import Fluent

struct CreateCV: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("cv_db")
            .id()
            .field("id_cv", .string)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("cv_db").delete()
    }
}
