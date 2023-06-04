//
//  RemoteNetworkServiceRepo.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

enum NetworkError: Error{
    case DecodeError
    case InvalidURL
    case NoResponse
    case Unauthorised
    case UnexpectedStatusCode
    case Unknown
}

protocol RemoteNetworkServiceRepo{
    func requestRemoteData<T:Decodable>() async -> Result<T, Error>
    func fetchImage(from url: String) async -> Result<Data?, Error>
}
