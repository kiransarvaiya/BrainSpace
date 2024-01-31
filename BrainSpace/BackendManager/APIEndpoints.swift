//
//  APIEndpoints.swift
//  BrainSpace
//
//  Created by Kiran Sarvaiya on 30/01/24.
//

import Foundation
import ObjectMapper

class ApiEndpoint<T: Mappable> {
    var config: BackendConfiguration {
        return BackendManager.defaultConfiguration
    }
}
