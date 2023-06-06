//
//  RemoteNetworkServiceRepo.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation


/// Used by Network service to provide with errors for different network issues
enum NetworkError: Error{
    case DecodeError
    case InvalidURL
    case NoResponse
    case Unauthorised
    case UnexpectedStatusCode
    case Unknown
}


/// Protocol confirmed by NetworkService to provide network call functionalities.
protocol RemoteNetworkServiceRepo{
    func requestRemoteData<T:Decodable>() async -> Result<T, Error>
    func fetchImage(from url: String) async -> Result<Data?, Error>
}
