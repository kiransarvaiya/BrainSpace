//
//  PostsModels.swift
//  BrainSpace
//
//  Created by Kiran Sarvaiya on 31/01/24.
//  Copyright (c) 2024 Kiran Sarvaiya. All rights reserved.

import UIKit

struct Posts {
    // MARK: Use cases
    
    struct fetchDetails {
        struct Request {
            var id: Int?
        }
        struct Response {
            var objResponse: PostsResponse
        }
        struct ViewModel {
            struct DisplayPostsData {
                var title: String?
                var body: String?
            }
            var postDetails: DisplayPostsData
        }
    }
    
    struct comments {
        struct Request {
            var id: Int?
        }
        struct Response {
            var objResponse: [CommentsResponse]?
        }
        struct ViewModel {
            struct DisplayCommentsData {
                var name: String?
                var body: String?
                var email: String?
            }
            var comments: [DisplayCommentsData]
        }
    }
}
