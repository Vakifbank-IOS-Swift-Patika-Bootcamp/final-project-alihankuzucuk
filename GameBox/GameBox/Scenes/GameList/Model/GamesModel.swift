//
//  GamesModel.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 8.12.2022.
//

import Foundation

// MARK: - GamesModel
struct GamesModel: Codable {
    let gameCount: Int
    let nextPage: String?
    let previousPage: String?
    let games: [GameModel]?

    enum CodingKeys: String, CodingKey {
        case gameCount = "count"
        case nextPage = "next"
        case previousPage = "previous"
        case games = "results"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gameCount = try values.decodeIfPresent(Int.self, forKey: .gameCount) ?? -1
        nextPage = try values.decodeIfPresent(String.self, forKey: .nextPage) ?? nil
        previousPage = try values.decodeIfPresent(String.self, forKey: .previousPage) ?? nil
        games = try values.decodeIfPresent([GameModel].self, forKey: .games) ?? []
    }
}

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
    let gamePlaytime: Int
    let gameParentPlatforms: [ParentPlatformModel]
    let gameGenres: [GenreModel]

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
        case gamePlaytime = "playtime"
        case gameParentPlatforms = "parent_platforms"
        case gameGenres = "genres"
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
        gamePlaytime = try values.decodeIfPresent(Int.self, forKey: .gamePlaytime) ?? -1
        gameParentPlatforms = try values.decodeIfPresent([ParentPlatformModel].self, forKey: .gameParentPlatforms) ?? []
        gameGenres = try values.decodeIfPresent([GenreModel].self, forKey: .gameGenres) ?? []
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
    let parentPlatformId: Int
    let parentPlatformName: String

    enum CodingKeys: String, CodingKey {
        case parentPlatformId = "id"
        case parentPlatformName = "name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        parentPlatformId = try values.decodeIfPresent(Int.self, forKey: .parentPlatformId) ?? -1
        parentPlatformName = try values.decodeIfPresent(String.self, forKey: .parentPlatformName) ?? ""
    }
}

// MARK: - GenreModel
struct GenreModel: Codable {
    let genreId: Int
    let genreName: String
    let genreSlug: String

    enum CodingKeys: String, CodingKey {
        case genreId = "id"
        case genreName = "name"
        case genreSlug = "slug"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        genreId = try values.decodeIfPresent(Int.self, forKey: .genreId) ?? -1
        genreName = try values.decodeIfPresent(String.self, forKey: .genreName) ?? ""
        genreSlug = try values.decodeIfPresent(String.self, forKey: .genreSlug) ?? ""
    }
}
