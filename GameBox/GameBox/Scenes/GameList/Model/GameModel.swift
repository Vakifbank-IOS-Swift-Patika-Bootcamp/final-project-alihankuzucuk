//
//  GameModel.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 8.12.2022.
//

import Foundation

// MARK: - GameModel
struct GameModel: Codable {
    let id: Int
    let slug: String
    let name: String
    let releaseDate: String
    let backgroundImage: String
    let rating: Double
    let ratingTop: Int
    let ratings: [RatingModel]
    let ratingsCount: Int
    let metacritic: Int
    let playtime: Int
    let parentPlatforms: [ParentPlatformModel]
    let genres: [CommonModel]
    let tags: [CommonModel]
    let esrbRating: CommonModel?
    
    // Properties after this line will be bounded by GameDetail endpoint
    let description: String
    let descriptionRaw: String
    let website: String

    enum CodingKeys: String, CodingKey {
        case id, slug, name
        case releaseDate = "released"
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case ratings
        case ratingsCount = "ratings_count"
        case metacritic, playtime
        case parentPlatforms = "parent_platforms"
        case genres = "genres"
        case tags = "tags"
        case esrbRating = "esrb_rating"
        case description = "description"
        case descriptionRaw = "description_raw"
        case website = "website"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
        slug = try values.decodeIfPresent(String.self, forKey: .slug) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        backgroundImage = try values.decodeIfPresent(String.self, forKey: .backgroundImage) ?? ""
        rating = try values.decodeIfPresent(Double.self, forKey: .rating) ?? -1
        ratingTop = try values.decodeIfPresent(Int.self, forKey: .ratingTop) ?? -1
        ratings = try values.decodeIfPresent([RatingModel].self, forKey: .ratings) ?? []
        ratingsCount = try values.decodeIfPresent(Int.self, forKey: .ratingsCount) ?? -1
        metacritic = try values.decodeIfPresent(Int.self, forKey: .metacritic) ?? 0
        playtime = try values.decodeIfPresent(Int.self, forKey: .playtime) ?? -1
        parentPlatforms = try values.decodeIfPresent([ParentPlatformModel].self, forKey: .parentPlatforms) ?? []
        genres = try values.decodeIfPresent([CommonModel].self, forKey: .genres) ?? []
        tags = try values.decodeIfPresent([CommonModel].self, forKey: .tags) ?? []
        esrbRating = try values.decodeIfPresent(CommonModel?.self, forKey: .esrbRating) ?? nil
        description = try values.decodeIfPresent(String.self, forKey: .description) ?? ""
        descriptionRaw = try values.decodeIfPresent(String.self, forKey: .descriptionRaw) ?? ""
        website = try values.decodeIfPresent(String.self, forKey: .website) ?? ""
    }
}

// MARK: - RatingModel
struct RatingModel: Codable {
    let id: Int
    let title: String
    let count: Int
    let percent: Double

    enum CodingKeys: String, CodingKey {
        case id, title, count, percent
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        count = try values.decodeIfPresent(Int.self, forKey: .count) ?? -1
        percent = try values.decodeIfPresent(Double.self, forKey: .percent) ?? -1
    }
}

// MARK: - ParentPlatformModel
struct ParentPlatformModel: Codable {
    let platform: CommonModel?
}

// MARK: - CommonModel
struct CommonModel: Codable {
    let id: Int
    let name: String
    let slug: String

    enum CodingKeys: String, CodingKey {
        case id, name, slug
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        slug = try values.decodeIfPresent(String.self, forKey: .slug) ?? ""
    }
}

// MARK: - ScreenshotModel
struct ScreenshotModel: Codable {
    let id: Int
    let image: String

    enum CodingKeys: String, CodingKey {
        case id, image
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
    }
}
