//
//  NetworkError.swift
//  LeagueSocial
//
//  Created by Arpit Williams on 03/04/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case noData
    case invalidURL
    case unauthorized
    case decodingFailed
    case unknown(Error)
    case requestFailed(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .noData: return "No data received."
        case .invalidURL: return "The URL is invalid."
        case .unauthorized: return "Unauthorized access."
        case .decodingFailed: return "Failed to decode the response."
        case .unknown(let error): return error.localizedDescription
        case .requestFailed(let code): return "Request failed with status code \(code)."
        }
    }
}
