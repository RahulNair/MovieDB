//
//  URLSessionProtocol.swift
//  TheMovieDB
//
//  Created by Rahul Nair on 12/03/21.
// 
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask
}
