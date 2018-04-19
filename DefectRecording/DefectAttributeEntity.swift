//
//  DefectAttributeEntity.swift
//  DefectTrackingApp
//
//  Created by Namthip Silsuwan on 3/2/2561 BE.
//  Copyright © 2561 Namthip Silsuwan. All rights reserved.
//

import Foundation
import ObjectMapper

class DefectAttributeEntity: Mappable {
    var type:[DefectType] = []
    var severity:[DefectSeverity] = []
    var priority:[DefectPrioritys] = []
    var status:[DefectStatus] = []
    var project:[Project] = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        severity <- map["severity"]
        priority <- map["priority"]
        status <- map["status"]
        project <- map["project"]
    }
}

class DefectCommonAttribute: Mappable {
    var id:Int = 0
    var name:String = ""
    var selected:Bool = false
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
}

class DefectType: DefectCommonAttribute{
    
    override func mapping(map: Map) {
        id <- map["typeID"]
        name <- map["typeName"]
    }
}

class DefectSeverity: DefectCommonAttribute{

    override func mapping(map: Map) {
        id <- map["severityID"]
        name <- map["severityName"]
    }
}

class DefectPrioritys: DefectCommonAttribute{
    
    override  func mapping(map: Map) {
        id <- map["priorityID"]
        name <- map["priorityName"]
    }
}

class DefectStatus: DefectCommonAttribute{
    
    override func mapping(map: Map) {
        id <- map["statusID"]
        name <- map["statusName"]
    }
}

class Project: DefectCommonAttribute{
    
    override func mapping(map: Map) {
        id <- map["projectID"]
        name <- map["projectName"]
    }
}
