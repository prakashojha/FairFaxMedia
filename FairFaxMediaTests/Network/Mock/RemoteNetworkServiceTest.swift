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
    
    /// initialise with initial values.
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
    
    
    /// Returns Data object for a given json file
    /// - Parameter resource: a json file in bundle
    /// - Returns: Option Data object
    private func getJSONData(from resource: String)->Data?{
        var data: Data?
        if let file = Bundle(for: type(of: self)).url(forResource: resource, withExtension: "json") {
            data = try! Data(contentsOf: file)
        }
        return data
    }
    
    /// For a valid network call a valid data and response is expected
    func test_getArticleData_WhenGivenValidDataAndResponse_ReturnsSuccess(){
        
        // Arrange
        let mockUrl = URL(string: urlString)!
        let response = HTTPURLResponse(url: mockUrl, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = getJSONData(from: "ValidResponse")
        
       
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
    
    /// For an invalid URL, `NetworkError.InvalidURL` error is expected
    func test_getArticleData_WhenInvalidURLStringProvided_ReturnsError(){
        
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
    
    /// For a network error, `NetworkError.Unknown` error is expected
    func test_getArticleData_WhenNetworkErrorProvided_ReturnsError(){
        // Arrange
      
        let failedError: Error? = NetworkError.Unknown
        URLProtocolMock.failedError = failedError
        
        sut = RemoteNetworkService(urlString: urlString, urlSession: urlSession)
        
        // Act
        Task{
            let result: Result<ArticleDataModel, Error> =  await sut.requestRemoteData()
            switch(result){
            case .failure(let error):
                XCTAssertEqual(failedError!.localizedDescription, error.localizedDescription, "WhenNetworkErrorProvided did not return expected error")
                self.expectation.fulfill()
            default:()
                
            }
        }
        waitForExpectations(timeout: 2)
    }
    
    /// For an empty URL, `NetworkError.InvalidURL` error is expected
    func test_getArticleData_WhenEmptyURLStringProvided_ReturnsError(){
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
    
    /// Check if the response if of type `HTTPURLResponse`, otherwise throw `NetworkError.NoResponse` error
    func test_getArticleData_WhenWrongURLResponseProvided_ReturnsError(){
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
    
    ///NetworkService download data from API call and decodes it as per the provided model. When wrong model is provided throws error `NetworkError.DecodeError`
    func test_getArticleData_WhenWrongModelProvided_ReturnsDecodeError(){
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
    
    ///For Unauthorised status code response (401), error `NetworkError.Unauthorised` is thrown
    func test_getArticleData_WhenUnAuthorisedStatusCodeProvided_ReturnsUnauthorisedError(){
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
    
    /// For Unexpected response, error `NetworkError.UnexpectedStatusCode` is thrown
    func test_getArticleData_WhenUnexpectedStatusCodeProvided_ReturnsUnauthorisedError(){
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
    
    
    
    ///When a valid string is provided a valid data of type `Data` is expected
    func test_fetchImage_WhenProvidedValidUrl_ReturnsSuccess(){
        
        // Arrange
        let mockUrl = URL(string: urlString)!
        let response = HTTPURLResponse(url: mockUrl, statusCode: 200, httpVersion: nil, headerFields: nil)
        //let error: Error? = nil
        let data: Data? = "hello world".data(using: .utf8)
        
       // URLProtocolMock.failedError = error
        URLProtocolMock.data = data
        URLProtocolMock.response = response
        URLProtocolMock.failedError = nil
        
        sut = RemoteNetworkService(urlString: urlString, urlSession: urlSession)
        
        // Act
        Task{
            let result: Result<Data?, Error> =  await sut.fetchImage(from: urlString)
            switch(result){
            case .success(let data):
                let stringData = String(decoding: data!, as: UTF8.self)
                XCTAssertEqual(stringData, "hello world")
                self.expectation.fulfill()
                
            default:()
                
            }
        }
        waitForExpectations(timeout: 5)
    }
    
    ///When fetching image for invalid URL , error `NetworkError.InvalidURL` is thrown
    func test_fetchImage_WhenProvidedInValidUrl_ReturnsFailure(){
        
        // Arrange
        let urlStr = "ww?%\"w"
        let failedError: Error? = NetworkError.InvalidURL
        sut = RemoteNetworkService(urlString: urlStr, urlSession: urlSession)
        
        // Act
        Task{
            let result: Result<Data?, Error> =  await sut.fetchImage(from: urlStr)
            switch(result){
            case .failure(let error):
                XCTAssertEqual(failedError!.localizedDescription, error.localizedDescription, "WhenInvalidURLStringProvided did not return expected error")
                self.expectation.fulfill()
            default:()
                
            }
        }
        waitForExpectations(timeout: 2)
    }
    
    /// When fetching image using empty URL, error `NetworkError.InvalidURL` is thrown/expected
    func test_fetchImage_WhenEmptyURLStringProvided_ReturnsError(){
        // Arrange
        
        let failedError: Error? = NetworkError.InvalidURL
        sut = RemoteNetworkService(urlString: "", urlSession: urlSession)
        
        // Act
        Task{
            let result: Result<Data?, Error> =  await sut.fetchImage(from: "")
            switch(result){
            case .failure(let error):
                XCTAssertEqual(failedError!.localizedDescription, error.localizedDescription, "WhenEmptyURLStringProvided did not return expected error")
                self.expectation.fulfill()
            default:()
                
            }
        }
        waitForExpectations(timeout: 5)
    }
    
    /// When fetching an image, when network error occurs error of type `NetworkError.Unknown` is expected
    func test_fetchImage_WhenNetworkErrorProvided_ReturnsError(){
        // Arrange
      
        let failedError: Error? = NetworkError.Unknown
        URLProtocolMock.failedError = failedError
        
        sut = RemoteNetworkService(urlString: urlString, urlSession: urlSession)
        
        // Act
        Task{
            let result: Result<Data?, Error> =  await sut.fetchImage(from: urlString)
            switch(result){
            case .failure(let error):
                XCTAssertEqual(failedError!.localizedDescription, error.localizedDescription, "WhenNetworkErrorProvided did not return expected error")
                self.expectation.fulfill()
            default:()
                
            }
        }
        waitForExpectations(timeout: 2)
    }
    
    ///When fetching an image, when wrong response arrives an error of type `NetworkError.NoResponse` is expected
    func test_fetchImage_WhenWrongResponseProvided_ReturnsError(){
        // Arrange
        let mockUrl = URL(string: urlString)!
        let response: URLResponse? =  URLResponse(url: mockUrl, mimeType: "application/json", expectedContentLength: -1, textEncodingName: nil)
        let failedError: Error? = NetworkError.NoResponse
        URLProtocolMock.response = response
        
        sut = RemoteNetworkService(urlString: urlString, urlSession: urlSession)
        
        // Act
        Task{
            let result: Result<Data?, Error> =  await sut.fetchImage(from: urlString)
            switch(result){
            case .failure(let error):
                XCTAssertEqual(failedError!.localizedDescription, error.localizedDescription, "WhenNoResponseProvided did not return expected error")
                self.expectation.fulfill()
            default:()
                
            }
        }
        waitForExpectations(timeout: 5)
    }
    
    /// When fetching an image, when unauthorised status code in  response is received then an error of type `NetworkError.Unauthorised` is expected
    func test_fetchImage_WhenUnAuthorisedStatusCodeProvided_ReturnsUnauthorisedError(){
        // Arrange
        let mockUrl = URL(string: urlString)!
        let response = HTTPURLResponse(url: mockUrl, statusCode: 401, httpVersion: nil, headerFields: nil)
        let failedError: Error? = NetworkError.Unauthorised
        let data: Data? = nil
        
        URLProtocolMock.failedError = nil
        URLProtocolMock.response = response
        URLProtocolMock.data = data
        
        sut = RemoteNetworkService(urlString: urlString, urlSession: urlSession)
        
        // Act
        Task{
            let result: Result<Data?, Error> =  await sut.fetchImage(from: urlString)
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
    
    /// When fetching an image, when unexpected status code in  response is received then an error of type `NetworkError.UnexpectedStatusCode` is expected
    func test_fetchImage_WhenUnexpectedStatusCodeProvided_ReturnsUnauthorisedError(){
        // Arrange
        let mockUrl = URL(string: urlString)!
        let response = HTTPURLResponse(url: mockUrl, statusCode: 520, httpVersion: nil, headerFields: nil)
        let failedError: Error? = NetworkError.UnexpectedStatusCode
        let data: Data? = nil
        
        URLProtocolMock.response = response
        URLProtocolMock.data = data
        
        sut = RemoteNetworkService(urlString: urlString, urlSession: urlSession)
        
        // Act
        Task{
            let result: Result<Data?, Error> =  await sut.fetchImage(from: urlString)
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

