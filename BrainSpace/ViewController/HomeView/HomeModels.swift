//
//  HomeModels.swift
//  BrainSpace
//
//  Created by Kiran Sarvaiya on 31/01/24.
//  Copyright (c) 2024 Kiran Sarvaiya. All rights reserved.

import UIKit

enum Home {
    // MARK: Use cases
    
    struct fetchLists {
        struct Request {
        }
        struct Response {
            var objResponse: [PostsResponse]?
        }
        struct ViewModel {
            struct DisplayPostsData {
                var title: String?
                var body: String?
            }
            var posts: [DisplayPostsData]
        }
    }
}
