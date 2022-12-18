//
//  RawGClient.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 8.12.2022.
//

import Foundation
import Alamofire

// MARK: RawGClient
final class RawGClient {
    
    // MARK: - Endpoints
    enum Endpoints: String {
        
        static let base = "https://api.rawg.io/api"
        
        case games = "games"
        case genres = "genres"
        
        // MARK: getUrlWith
        /// Creates and returns a url by appending each element in the queryParameters array to the queryString
        /// - Parameter queryParameters: Parameter array of type [Key : Value]
        /// - Returns: URL address complete with parameters
        func getUrlWith(endpointPostfix: String = "", queryParameters: [String:String]?) -> URL {
            var urlString = Endpoints.base
            urlString += "/\(self.rawValue)"
            urlString += endpointPostfix
            urlString += "?key=\(Constants.API_KEY)"

            guard let queryParameters = queryParameters else { return URL(string: urlString)! }

            queryParameters.forEach { queryParameter in
                urlString += "&\(queryParameter.key)=\(queryParameter.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
            }
            
            return URL(string: urlString)!
        }
        
    }
    
    // MARK: - handleResponse
    /// Make a request to the given url and returns given response
    /// - Parameters:
    ///   - url: Url address of where you want to make a request
    ///   - responseType: Type of response
    ///   - completion: Completion of where you handle response
    static private func handleResponse<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        AF.request(url).response { response in
            guard let data = response.value else {
                DispatchQueue.main.async {
                    completion(nil, response.error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data!)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        
    }
    
    // MARK: - getGamesInRange
    /// Makes a request to the /games endpoint and returns games in given range as parameter
    /// - Parameters:
    ///   - page: Parameter of which page you want to request
    ///   - pageSize: Parameter of how many items you want to see
    ///   - queryFilters: Parameter array of type [Key : Value]
    ///   - completion: Completion of where you handle response
    static func getGamesInRange(page: Int = 1, pageSize: Int = 30, queryFilters: [String:String]? = nil, completion: @escaping (BaseResponseModel<GameModel>?, Error?) -> Void) {
        var queryParameters = ["page":String(page),"page_size":String(pageSize)]
        
        if let queryFilters = queryFilters {
            queryFilters.forEach { queryFilter in
                queryParameters[queryFilter.key] = queryFilter.value
            }
        }
        
        handleResponse(url: Endpoints.games.getUrlWith(queryParameters: queryParameters), responseType: BaseResponseModel<GameModel>.self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    // MARK: - getAllGenres
    /// Makes a request to the /genres endpoint and returns all genres
    /// - Parameter completion: Completion of where you handle response
    static func getAllGenres(completion: @escaping (BaseResponseModel<CommonModel>?, Error?) -> Void) {
        handleResponse(url: Endpoints.genres.getUrlWith(queryParameters: nil), responseType: BaseResponseModel<CommonModel>.self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    // MARK: - getGameDetail
    /// Puts /{gameId} after /games Endpoint and makes a request to the /games endpoint then returns game detail
    /// - Parameters:
    ///   - gameId: Id of the entity which you want to get detail
    ///   - completion: Completion of where you handle response
    static func getGameDetail(gameId: Int, completion: @escaping (GameModel?, Error?) -> Void) {
        handleResponse(url: Endpoints.games.getUrlWith(endpointPostfix: "/\(gameId)", queryParameters: nil), responseType: GameModel?.self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    // MARK: - getGameScreenshots
    /// Puts /{gameId}/screenshots after /games Endpoint and makes a request to the /games endpoint then returns game screenshots
    /// - Parameters:
    ///   - gameId: Id of the entity which you want to get screenshots
    ///   - completion: Completion of where you handle response
    static func getGameScreenshots(gameId: Int, completion: @escaping (BaseResponseModel<ScreenshotModel>?, Error?) -> Void) {
        handleResponse(url: Endpoints.games.getUrlWith(endpointPostfix: "/\(gameId)/screenshots", queryParameters: nil), responseType: BaseResponseModel<ScreenshotModel>.self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
}
