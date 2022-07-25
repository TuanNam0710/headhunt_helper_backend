//
//  File.swift
//  
//
//  Created by Phạm Lê Tuấn Nam on 21/07/2022.
//

import Fluent
import Vapor

struct CVDetail: Content {
    var basicInfo: CV
    var skill: [Skills]
    var workExperience: [WorkExperience]
    var additionalInfo: [AdditionalInfo]
}
