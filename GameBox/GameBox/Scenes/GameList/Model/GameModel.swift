//
//  GameModel.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 8.12.2022.
//

import Foundation

// MARK: - GameModel
struct GameModel: Codable {
    let gameId: Int
    let gameSlug: String
    let gameName: String
    let gameReleaseDate: String
    let gameBackgroundImage: String
    let gameRating: Double
    let gameRatingTop: Int
    let gameRatings: [RatingModel]
    let gameRatingsCount: Int
    let gameMetacritic: Int
    let gamePlaytime: Int
    let gameParentPlatforms: [ParentPlatformModel]
    let gameGenres: [CommonModel]
    let gameTags: [CommonModel]
    let gameEsrbRating: CommonModel?
    // Properties after this line will be bounded by GameDetail endpoint
    let gameDescription: String
    let gameDescriptionRaw: String
    let gameWebsite: String

    enum CodingKeys: String, CodingKey {
        case gameId = "id"
        case gameSlug = "slug"
        case gameName = "name"
        case gameReleaseDate = "released"
        case gameBackgroundImage = "background_image"
        case gameRating = "rating"
        case gameRatingTop = "rating_top"
        case gameRatings = "ratings"
        case gameRatingsCount = "ratings_count"
        case gameMetacritic = "metacritic"
        case gamePlaytime = "playtime"
        case gameParentPlatforms = "parent_platforms"
        case gameGenres = "genres"
        case gameTags = "tags"
        case gameEsrbRating = "esrb_rating"
        case gameDescription = "description"
        case gameDescriptionRaw = "description_raw"
        case gameWebsite = "website"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gameId = try values.decodeIfPresent(Int.self, forKey: .gameId) ?? -1
        gameSlug = try values.decodeIfPresent(String.self, forKey: .gameSlug) ?? ""
        gameName = try values.decodeIfPresent(String.self, forKey: .gameName) ?? ""
        gameReleaseDate = try values.decodeIfPresent(String.self, forKey: .gameReleaseDate) ?? ""
        gameBackgroundImage = try values.decodeIfPresent(String.self, forKey: .gameBackgroundImage) ?? ""
        gameRating = try values.decodeIfPresent(Double.self, forKey: .gameRating) ?? -1
        gameRatingTop = try values.decodeIfPresent(Int.self, forKey: .gameRatingTop) ?? -1
        gameRatings = try values.decodeIfPresent([RatingModel].self, forKey: .gameRatings) ?? []
        gameRatingsCount = try values.decodeIfPresent(Int.self, forKey: .gameRatingsCount) ?? -1
        gameMetacritic = try values.decodeIfPresent(Int.self, forKey: .gameMetacritic) ?? 0
        gamePlaytime = try values.decodeIfPresent(Int.self, forKey: .gamePlaytime) ?? -1
        gameParentPlatforms = try values.decodeIfPresent([ParentPlatformModel].self, forKey: .gameParentPlatforms) ?? []
        gameGenres = try values.decodeIfPresent([CommonModel].self, forKey: .gameGenres) ?? []
        gameTags = try values.decodeIfPresent([CommonModel].self, forKey: .gameTags) ?? []
        gameEsrbRating = try values.decodeIfPresent(CommonModel?.self, forKey: .gameEsrbRating) ?? nil
        gameDescription = try values.decodeIfPresent(String.self, forKey: .gameDescription) ?? ""
        gameDescriptionRaw = try values.decodeIfPresent(String.self, forKey: .gameDescriptionRaw) ?? ""
        gameWebsite = try values.decodeIfPresent(String.self, forKey: .gameWebsite) ?? ""
    }
}

// MARK: - RatingModel
struct RatingModel: Codable {
    let ratingId: Int
    let ratingTitle: String
    let ratingCount: Int
    let ratingPercent: Double

    enum CodingKeys: String, CodingKey {
        case ratingId = "id"
        case ratingTitle = "title"
        case ratingCount = "count"
        case ratingPercent = "percent"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ratingId = try values.decodeIfPresent(Int.self, forKey: .ratingId) ?? -1
        ratingTitle = try values.decodeIfPresent(String.self, forKey: .ratingTitle) ?? ""
        ratingCount = try values.decodeIfPresent(Int.self, forKey: .ratingCount) ?? -1
        ratingPercent = try values.decodeIfPresent(Double.self, forKey: .ratingPercent) ?? -1
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
        case id = "id"
        case name = "name"
        case slug = "slug"
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
    let screenshotId: Int
    let screenshotImage: String

    enum CodingKeys: String, CodingKey {
        case screenshotId = "id"
        case screenshotImage = "image"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        screenshotId = try values.decodeIfPresent(Int.self, forKey: .screenshotId) ?? -1
        screenshotImage = try values.decodeIfPresent(String.self, forKey: .screenshotImage) ?? ""
    }
}
