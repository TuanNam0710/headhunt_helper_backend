//
//  File.swift
//  
//
//  Created by Phạm Lê Tuấn Nam on 06/07/2022.
//

import Fluent
import Vapor

final class Department: Model, Content {
    
    static let schema = "department_db"
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "name")
    var name: String
    
    init() { }
    
    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
