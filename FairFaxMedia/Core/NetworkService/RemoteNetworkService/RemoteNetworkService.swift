//
//  RemoteNetworkServiceRepoImpl.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

/// Network service to get data from remote network calls
/// accepts an url and session
class RemoteNetworkService: RemoteNetworkServiceRepo{
    
    private let urlString: String
    private var urlSession: URLSession
    
    required init(urlString: String, urlSession: URLSession = .shared) {
        self.urlString = urlString
        self.urlSession = urlSession
    }
    
    /// Get data from remote. Decodes the data into given decodable format.
    /// Check for  network errors
    /// - Returns: ResultType. OnSuccess returns decoded data. On failure return NetworkError
    func requestRemoteData<T:Decodable>() async -> Result<T, Error> {
        
        guard let url = URL(string: urlString) else {
            return .failure(NetworkError.InvalidURL)
        }
        
        let responseAndData = try? await urlSession.data(from: url)
        guard let (data, response) = responseAndData else{
            return .failure(NetworkError.Unknown)
        }
        
        //check if response is HTTPURLResponse.
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
    
    
    
    /// <#Description#>
    /// - Parameter url: url string to fetch image from
    /// - Returns: Result type. On Success returns Data?. On error return network error
    func fetchImage(from url: String) async -> Result<Data?, Error>{
        
        guard let url = URL(string: url) else {
            return .failure(NetworkError.InvalidURL)
        }
        
        let responseAndData = try? await urlSession.data(from: url)
        guard let (data, response) = responseAndData else{
            return .failure(NetworkError.Unknown)
        }
        
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
    
}

