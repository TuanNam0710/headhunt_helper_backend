//
//  File.swift
//  
//
//  Created by Phạm Lê Tuấn Nam on 21/07/2022.
//

import Vapor

struct ChangeDetailRequest: Content {
    var id: Int
    var idDept: Int?
    var idRecruiter: Int?
    var status: Int
}
