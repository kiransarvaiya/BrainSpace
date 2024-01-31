//
//  PostsResponse.swift
//  Demo
//
//  Created by Medionce Solutions on 28/08/19.
//  Copyright © 2019 demo. All rights reserved.
//

import Foundation
import ObjectMapper

struct PostsResponse: Mappable {
    var userId: Int?
    var id: Int?
    var title: String?
    var body: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        userId <- map["userId"]
        id <- map["id"]
        title <- map["title"]
        body <- map["body"]
    }
    
}

struct CommentsResponse: Mappable {
    var postId: Int?
    var id: Int?
    var name: String?
    var body: String?
    var email: String?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        postId <- map["postId"]
        id <- map["id"]
        name <- map["name"]
        body <- map["body"]
        email <- map["email"]
        
    }
}
