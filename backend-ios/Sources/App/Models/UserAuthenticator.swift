//
//  File.swift
//  
//
//  Created by Phạm Lê Tuấn Nam on 07/07/2022.
//

import Vapor

struct UserAuth: Authenticatable {
    var name: String
}

struct UserAuthenticator: AsyncBasicAuthenticator {
    typealias UserAuth = App.UserAuth

    func authenticate(
        basic: BasicAuthorization,
        for request: Request
    ) async throws {
        if basic.username == "admin" && basic.password == "admin" {
            request.auth.login(UserAuth(name: "Admin"))
        }
   }
}
