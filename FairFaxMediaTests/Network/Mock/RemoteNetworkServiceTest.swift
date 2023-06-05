//
//  ArticleDataServiceTest.swift
//  FairFaxMediaTests
//
//  Created by bindu.ojha on 5/06/23.
//

import XCTest
@testable import FairFaxMedia

final class RemoteNetworkServiceTest: XCTestCase {
    
    var config: URLSessionConfiguration!
    var urlSession: URLSession!
    let urlString = "https://urlRequestedMock.co.nz"
    var expectation: XCTestExpectation!
    var sut: RemoteNetworkService!
    
    override func setUpWithError() throws {
        config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        urlSession = URLSession(configuration: config)
        expectation = self.expectation(description: "RemoteNetworkServiceTestExpectation")
        sut = RemoteNetworkService(urlString: urlString, urlSession: urlSession)
    }
    
    override func tearDownWithError() throws {
        config = nil
        urlSession = nil
        sut = nil
    }
    
    private func getJSONData(from resource: String)->Data?{
        var data: Data?
        if let file = Bundle(for: type(of: self)).url(forResource: resource, withExtension: "json") {
            data = try! Data(contentsOf: file)
        }
        return data
    }
    
    func testRemoteNetworkService_WhenGivenSuccessfulResponse_ReturnsSuccess(){
        
        // Arrange
        let mockUrl = URL(string: urlString)!
        let response = HTTPURLResponse(url: mockUrl, statusCode: 200, httpVersion: nil, headerFields: nil)
        let error: Error? = nil
        let data = getJSONData(from: "ValidResponse")
        
        URLProtocolMock.failedError = error
        URLProtocolMock.data = data
        URLProtocolMock.response = response
        
        // Act
        Task{
            let result: Result<ArticleDataModel, Error> =  await sut.requestRemoteData()
            switch(result){
            case .success(let articleDataModel):
                XCTAssert(articleDataModel.assets?.first?.author == "Test1")
                self.expectation.fulfill()
                
            default:()
                
            }
        }
        waitForExpectations(timeout: 2)
    }
    
    func testRemoteNetworkService_WhenInvalidURLStringProvided_ReturnsError(){
        // Arrange
    
        let failedError: Error? = NetworkError.InvalidURL
        sut = RemoteNetworkService(urlString: "ww?%\"w", urlSession: urlSession)
    
        // Act
        Task{
            let result: Result<ArticleDataModel, Error> =  await sut.requestRemoteData()
            switch(result){
            case .failure(let error):
                XCTAssertEqual(failedError!.localizedDescription, error.localizedDescription, "WhenInvalidURLStringProvided did not return expected error")
                self.expectation.fulfill()
            default:()
                
            }
        }
        waitForExpectations(timeout: 2)
    }
    
    func testRemoteNetworkService_WhenEmptyURLStringProvided_ReturnsError(){
        // Arrange
      
        let failedError: Error? = NetworkError.InvalidURL
        sut = RemoteNetworkService(urlString: "", urlSession: urlSession)
    
        // Act
        Task{
            let result: Result<ArticleDataModel, Error> =  await sut.requestRemoteData()
            switch(result){
            case .failure(let error):
                XCTAssertEqual(failedError!.localizedDescription, error.localizedDescription, "WhenEmptyURLStringProvided did not return expected error")
                self.expectation.fulfill()
            default:()
                
            }
        }
        waitForExpectations(timeout: 5)
    }
    
    func testRemoteNetworkService_WhenNoResponseProvided_ReturnsError(){
        // Arrange
        let mockUrl = URL(string: urlString)!
        let response: URLResponse? =  URLResponse(url: mockUrl, mimeType: "application/json", expectedContentLength: -1, textEncodingName: nil)
        let failedError: Error? = NetworkError.NoResponse
        URLProtocolMock.response = response
        
        sut = RemoteNetworkService(urlString: urlString, urlSession: urlSession)
    
        // Act
        Task{
            let result: Result<ArticleDataModel, Error> =  await sut.requestRemoteData()
            switch(result){
            case .failure(let error):
                XCTAssertEqual(failedError!.localizedDescription, error.localizedDescription, "WhenNoResponseProvided did not return expected error")
                self.expectation.fulfill()
            default:()
                
            }
        }
        waitForExpectations(timeout: 5)
    }
    
    func testRemoteNetworkService_WhenWrongModelProvided_ReturnsDecodeError(){
        // Arrange
        let mockUrl = URL(string: urlString)!
        let response = HTTPURLResponse(url: mockUrl, statusCode: 200, httpVersion: nil, headerFields: nil)
        let failedError: Error? = NetworkError.DecodeError
        let data = getJSONData(from: "ValidResponse")
        
        URLProtocolMock.response = response
        URLProtocolMock.data = data
        
        sut = RemoteNetworkService(urlString: urlString, urlSession: urlSession)
    
        // Act
        Task{
            let result: Result<InvalidArticleModel, Error> =  await sut.requestRemoteData()
            switch(result){
            case .failure(let error):
                //Assert
                XCTAssertEqual(failedError!.localizedDescription, error.localizedDescription, "WhenWrongModelProvided did not return expected error")
                self.expectation.fulfill()
            default:()
            }
        }
        waitForExpectations(timeout: 5)
    }
    
    func testRemoteNetworkService_WhenUnAuthorisedStatusCodeProvided_ReturnsUnauthorisedError(){
        // Arrange
        let mockUrl = URL(string: urlString)!
        let response = HTTPURLResponse(url: mockUrl, statusCode: 401, httpVersion: nil, headerFields: nil)
        let failedError: Error? = NetworkError.Unauthorised
        let data = getJSONData(from: "ValidResponse")
        
        URLProtocolMock.response = response
        URLProtocolMock.data = data
        
        sut = RemoteNetworkService(urlString: urlString, urlSession: urlSession)
    
        // Act
        Task{
            let result: Result<InvalidArticleModel, Error> =  await sut.requestRemoteData()
            switch(result){
            case .failure(let error):
                //Assert
                XCTAssertEqual(failedError!.localizedDescription, error.localizedDescription, "WhenUnAuthorisedStatusCodeProvided did not return expected error")
                self.expectation.fulfill()
            default:()
            }
        }
        waitForExpectations(timeout: 5)
    }
    
    func testRemoteNetworkService_WhenUnexpectedStatusCodeProvided_ReturnsUnauthorisedError(){
        // Arrange
        let mockUrl = URL(string: urlString)!
        let response = HTTPURLResponse(url: mockUrl, statusCode: 520, httpVersion: nil, headerFields: nil)
        let failedError: Error? = NetworkError.UnexpectedStatusCode
        let data = getJSONData(from: "ValidResponse")
        
        URLProtocolMock.response = response
        URLProtocolMock.data = data
        
        sut = RemoteNetworkService(urlString: urlString, urlSession: urlSession)
    
        // Act
        Task{
            let result: Result<InvalidArticleModel, Error> =  await sut.requestRemoteData()
            switch(result){
            case .failure(let error):
                //Assert
                XCTAssertEqual(failedError!.localizedDescription, error.localizedDescription, "WhenUnexpectedStatusCodeProvided did not return expected error")
                self.expectation.fulfill()
            default:()
            }
        }
        waitForExpectations(timeout: 5)
    }
    
}
