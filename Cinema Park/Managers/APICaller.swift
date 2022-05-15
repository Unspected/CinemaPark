//
//  APICaller.swift
//  Cinema Park
//
//  Created by Pavel Andreev on 4/20/22.
//

import Foundation
import UIKit

struct Constants {
    
    static let API_KEY = "7e7ff1533edade4477dfa7a6951456a9"
    static let baseURL = "https://api.themoviedb.org"
    static let youTubeAPI_KEY = "AIzaSyCynWX_FHFfQZa5L4BUCZyRGyO6K8C_96o"
    static let youTubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failtToGetData
}

class APICaller {
    
    static let share = APICaller()
    
    func getTrendingMovies(complition: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else { return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else  { return }
            
            do {
                let results = try JSONDecoder().decode(TrandingTitleResponse.self, from: data)
                complition(.success(results.results))
                
            } catch {
                complition(.failure(APIError.failtToGetData))
            }
        }
        task.resume()
        
    }
    
    func getTrendingTV(complition: @escaping (Result<[Title], Error>) -> Void) {

        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else { return}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else  { return }
            
            do {
                let results = try JSONDecoder().decode(TrandingTitleResponse.self, from: data)
                complition(.success(results.results))
                
            } catch {
                complition(.failure(APIError.failtToGetData))
            }
        }
        task.resume()
        
    }
    
    func getUpComingMovies(complition: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _ , error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrandingTitleResponse.self, from: data)
                complition(.success(results.results))
            } catch {
                complition(.failure(APIError.failtToGetData))
            }
        }
        task.resume()
        
    }
    
    func getPopular(complition: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _ , error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrandingTitleResponse.self, from: data)
                complition(.success(results.results))
            } catch {
                complition(.failure(APIError.failtToGetData))
            }
        }
        task.resume()
    }
    
    func getTopRated(complition: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _ , error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrandingTitleResponse.self, from: data)
                complition(.success(results.results))
            } catch {
                complition(.failure(APIError.failtToGetData))
            }
        }
        task.resume()
    }
    
    func getDiscoverMovies(complition: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _ , error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrandingTitleResponse.self, from: data)
                complition(.success(results.results))
            } catch {
                complition(.failure(APIError.failtToGetData))
            }
        }
        task.resume()
    }
    
    func search(with query: String, complition: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _ , error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrandingTitleResponse.self, from: data)
                complition(.success(results.results))
            } catch {
                complition(.failure(APIError.failtToGetData))
            }
        }
        task.resume()
    }
    
    func getMovie(with query: String, complition: @escaping (Result<VideoElement, Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.youTubeBaseURL)q=\(query)&key=\(Constants.youTubeAPI_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _ , error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data)
                complition(.success(results.items[0]))
                
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
