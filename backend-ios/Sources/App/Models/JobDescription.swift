//
//  File.swift
//  
//
//  Created by Phạm Lê Tuấn Nam on 21/07/2022.
//

import Fluent
import Vapor

final class JobDescription: Model, Content {
    
    static let schema = "job_description_db"
    
    @ID(custom: "id")
    var id: Int?
    
    @ID(custom: "id_position")
    var idPosition: Int?
    
    @Field(key: "job_description")
    var jobDescription: String
    
    @Field(key: "no_of_jobs")
    var noOfJobs: Int
    
    @Field(key: "due_date")
    var dueDate: String
    
    init() { }
    
    init(id: Int? = nil,
         idPosition: Int? = nil,
         jobDescription: String,
         noOfJobs: Int,
         dueDate: String) {
        self.id = id
        self.idPosition = idPosition
        self.jobDescription = jobDescription
        self.noOfJobs = noOfJobs
        self.dueDate = dueDate
    }
}
