//
//  File.swift
//  
//
//  Created by Pham Le Tuan Nam on 03/07/2022.
//

import Fluent
import Vapor

final class CV: Model, Content {
    static let schema = "Test"
    
    @ID(custom: "id_cv")
    var id: UUID?
    
    @Field(key: "name_candidate")
    var name: String
    
    @Field(key: "person_in_charge_id")
    var picId: Int?
    
    @Field(key: "job_id")
    var jobId: Int
    
    init() { }
    
    init(id: UUID? = nil, name: String, picId: Int?, jobId: Int) {
        self.id = id
        self.name = name
        self.picId = picId
        self.jobId = jobId
    }
}
