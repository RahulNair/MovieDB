//
//  URLSessionExtensions.swift
//  TheMovieDB
//
//  Created by Rahul Nair on 12/03/21.
// 
//

import Foundation

extension URLSession: URLSessionProtocol {
    func dataTask(request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask {
        return dataTask(with: request, completionHandler: completionHandler)
    }
}
