//
//  MockURLProtocol.swift
//  FairFaxMediaTests
//
//  Created by bindu.ojha on 5/06/23.
//

import Foundation

class URLProtocolMock: URLProtocol{
    
    static var data: Data?
    static var failedError: Error?
    static var response: URLResponse?
    
    //static var mockURLs = [URL?: (error: Error?, data: Data?, response: HTTPURLResponse?)]()
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let _ = request.url {
            // if let (error, data, response) = URLProtocolMock.mockURLs[url] {
            
            // We have a mock response specified so return it.
            if let responseStrong = URLProtocolMock.response {
                self.client?.urlProtocol(self, didReceive: responseStrong, cacheStoragePolicy: .notAllowed)
            }
            
            // We have mocked data specified so return it.
            if let dataStrong = URLProtocolMock.data {
                self.client?.urlProtocol(self, didLoad: dataStrong)
            }
            
            // We have a mocked error so return it.
            if let errorStrong = URLProtocolMock.failedError {
                self.client?.urlProtocol(self, didFailWithError: errorStrong)
            }
            //}
        }
        
        // Send the signal that we are done returning our mock response
        self.client?.urlProtocolDidFinishLoading(self)
        
    }
    
    override func stopLoading() {
    }
}
