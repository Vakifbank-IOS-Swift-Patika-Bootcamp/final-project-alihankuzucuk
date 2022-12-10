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
    let gameGenres: [GenreModel]
    let gameTags: [TagModel]
    let gameEsrbRating: EsrbRatingModel?
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
        gameMetacritic = try values.decodeIfPresent(Int.self, forKey: .gameMetacritic) ?? -1
        gamePlaytime = try values.decodeIfPresent(Int.self, forKey: .gamePlaytime) ?? -1
        gameParentPlatforms = try values.decodeIfPresent([ParentPlatformModel].self, forKey: .gameParentPlatforms) ?? []
        gameGenres = try values.decodeIfPresent([GenreModel].self, forKey: .gameGenres) ?? []
        gameTags = try values.decodeIfPresent([TagModel].self, forKey: .gameTags) ?? []
        gameEsrbRating = try values.decodeIfPresent(EsrbRatingModel?.self, forKey: .gameEsrbRating) ?? nil
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

// MARK: - TagModel
struct TagModel: Codable {
    let tagId: Int
    let tagName: String
    let tagSlug: String

    enum CodingKeys: String, CodingKey {
        case tagId = "id"
        case tagName = "name"
        case tagSlug = "slug"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        tagId = try values.decodeIfPresent(Int.self, forKey: .tagId) ?? -1
        tagName = try values.decodeIfPresent(String.self, forKey: .tagName) ?? ""
        tagSlug = try values.decodeIfPresent(String.self, forKey: .tagSlug) ?? ""
    }
}

// MARK: - EsrbRatingModel
struct EsrbRatingModel: Codable {
    let esrbRatingId: Int
    let esrbRatingName: String
    let esrbRatingSlug: String

    enum CodingKeys: String, CodingKey {
        case esrbRatingId = "id"
        case esrbRatingName = "name"
        case esrbRatingSlug = "slug"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        esrbRatingId = try values.decodeIfPresent(Int.self, forKey: .esrbRatingId) ?? -1
        esrbRatingName = try values.decodeIfPresent(String.self, forKey: .esrbRatingName) ?? ""
        esrbRatingSlug = try values.decodeIfPresent(String.self, forKey: .esrbRatingSlug) ?? ""
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
