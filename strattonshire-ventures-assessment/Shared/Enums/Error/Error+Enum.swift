//
//  NetworkError+Enum.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/2/24.
//

enum AppError: Error {
    case weakReference
}

enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
    case requestTimeout
    case statusCodeNotSuccess
    case jsonDecodeFailure(Error)
}
