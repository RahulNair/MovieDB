//
//  Service.swift
//  TheMovieDB
//
//  Created by Rahul Nair on 12/03/21.
// 
//

import Foundation

protocol Service {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: Task { get }
    var headers: RequestHeaders? { get }
    var parametersEncoding: ParametersEncoding { get }
}
