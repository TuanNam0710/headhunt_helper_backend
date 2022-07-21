//
//  File.swift
//  
//
//  Created by Phạm Lê Tuấn Nam on 21/07/2022.
//

import Fluent
import Vapor

final class Position: Model, Content {
    
    static let schema = "position_db"
    
    @ID(custom: "id")
    var id: Int?
    
    @ID(custom: "id_department")
    var idDepartment: Int?
    
    @Field(key: "name")
    var name: String
    
    init() { }
    
    init(id: Int? = nil, idDepartment: Int? = nil, name: String) {
        self.id = id
        self.idDepartment = idDepartment
        self.name = name
    }
}
