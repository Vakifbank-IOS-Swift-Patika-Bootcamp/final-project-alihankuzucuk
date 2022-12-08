//
//  BaseResponseModel.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 8.12.2022.
//

import Foundation

// MARK: - BaseResponseModel
struct BaseResponseModel<T>: Codable where T: Codable {
    let responseCount: Int
    let nextPage: String?
    let previousPage: String?
    let results: [T]?

    enum CodingKeys: String, CodingKey {
        case responseCount = "count"
        case nextPage = "next"
        case previousPage = "previous"
        case results = "results"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        responseCount = try values.decodeIfPresent(Int.self, forKey: .responseCount) ?? -1
        nextPage = try values.decodeIfPresent(String.self, forKey: .nextPage) ?? nil
        previousPage = try values.decodeIfPresent(String.self, forKey: .previousPage) ?? nil
        results = try values.decodeIfPresent([T].self, forKey: .results) ?? []
    }
}
