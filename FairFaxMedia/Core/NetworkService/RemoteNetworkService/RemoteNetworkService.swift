//
//  RemoteNetworkServiceRepoImpl.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

class RemoteNetworkService: RemoteNetworkServiceRepo{
    
    private let urlString: String
    private var urlSession: URLSession
    
    required init(urlString: String, urlSession: URLSession = .shared) {
        self.urlString = urlString
        self.urlSession = urlSession
    }
    
    func requestRemoteData<T:Decodable>() async throws -> Result<T, Error> {
        
        guard let url = URL(string: urlString) else {
            return .failure(NetworkError.InvalidURL)
        }
        
        do{
            let (data, response) = try await urlSession.data(from: url)
            guard let response = response as? HTTPURLResponse else {
                return .failure(NetworkError.NoResponse)
            }
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                    return .failure(NetworkError.DecodeError)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(NetworkError.Unauthorised)
            default:
                return .failure(NetworkError.UnexpectedStatusCode)
            }
        }
        catch{
            return .failure(NetworkError.Unknown)
        }
    }
    
    
    func fetchImage(from url: String) async throws -> Result<Data?, Error>{
        
        guard let url = URL(string: url) else {
            return .failure(NetworkError.InvalidURL)
        }
        
        do{
            let (data, response) = try await urlSession.data(from: url)
            guard let response = response as? HTTPURLResponse else {
                return .failure(NetworkError.NoResponse)
            }
            switch response.statusCode {
            case 200...299:
                return .success(data)
            case 401:
                return .failure(NetworkError.Unauthorised)
            default:
                return .failure(NetworkError.UnexpectedStatusCode)
            }
        }
        catch{
            return .failure(NetworkError.Unknown)
        }
        
    }
    
}
