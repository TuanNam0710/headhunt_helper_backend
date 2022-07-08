//
//  File.swift
//  
//
//  Created by Pham Le Tuan Nam on 03/07/2022.
//

import Fluent
import Vapor

final class CV: Model, Content {
    
    static let schema = "cv_db"
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "gender")
    var gender: Int
    
    @Field(key: "position")
    var position: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "phone")
    var phone: String
    
    @ID(custom: "id_recruiter")
    var idRecruiter: Int?
    
    @Field(key: "status")
    var status: Int
    
    @ID(custom: "id_department")
    var idDepartment: Int?
    
    init() { }
    
    init(id: Int? = nil,
         name: String,
         gender: Int,
         position: String,
         email: String,
         phone: String,
         idRecruiter: Int? = nil,
         status: Int,
         idDepartment: Int? = nil) {
        self.id = id
        self.name = name
        self.gender = gender
        self.position = position
        self.email = email
        self.phone = phone
        self.idRecruiter = idRecruiter
        self.status = status
        self.idDepartment = idDepartment
    }
}

final class Skills: Model, Content {
    
    static let schema = "cv_skills"
    
    @ID(custom: "id")
    var id: Int?
    
    @ID(custom: "id_cv")
    var idCV: Int?
    
    @Field(key: "skills_detail")
    var detail: String
    
    init() { }
    
    init(id: Int? = nil, idCV: Int? = nil, detail: String) {
        self.id = id
        self.idCV = idCV
        self.detail = detail
    }
}

final class WorkExperience: Model, Content {
    
    static let schema = "cv_work_experience"
    
    @ID(custom: "id")
    var id: Int?
    
    @ID(custom: "id_cv")
    var idCV: Int?
    
    @Field(key: "company_name")
    var companyName: String
    
    @Field(key: "position")
    var position: String
    
    @Field(key: "detail")
    var detail: String
    
    @Field(key: "start_time")
    var startTime: String
    
    @Field(key: "end_time")
    var endTime: String
    
    init() { }
    
    init(id: Int? = nil,
         idCV: Int? = nil,
         companyName: String,
         position: String,
         detail: String,
         startTime: String,
         endTime: String) {
        self.id = id
        self.idCV = idCV
        self.companyName = companyName
        self.position = position
        self.detail = detail
        self.startTime = startTime
        self.endTime = endTime
    }
}

final class AdditionalInfo: Model, Content {
    
    static let schema = "cv_additional_info"
    
    @ID(custom: "id")
    var id: Int?
    
    @ID(custom: "id_cv")
    var idCV: Int?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "detail")
    var detail: String
    
    init() { }
    
    init(id: Int? = nil, idCV: Int? = nil, title: String, detail: String) {
        self.id = id
        self.idCV = idCV
        self.title = title
        self.detail = detail
    }
}
