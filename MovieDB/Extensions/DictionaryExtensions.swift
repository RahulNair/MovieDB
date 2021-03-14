//
//  DictionaryExtensions.swift
//  TheMovieDB
//
// Created by Rahul Nair on 12/03/21.
// 
//

import Foundation

extension Dictionary {
    mutating func append(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
