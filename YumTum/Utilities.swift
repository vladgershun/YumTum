//
//  Utilities.swift
//  YumTum
//
//  Created by Vlad Gershun on 1/10/23.
//

import Foundation

enum ErrorType: LocalizedError {
    case badConnection
    case notDecodable
    var errorDescription: String? {
        switch self {
        case .badConnection:
            return "Bad Connection"
        case .notDecodable:
            return "Bad Data"
        }
    }
}
