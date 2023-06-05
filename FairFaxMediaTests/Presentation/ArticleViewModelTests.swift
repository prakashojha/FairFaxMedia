//
//  AlertViewModelTests.swift
//  FairFaxMediaTests
//
//  Created by bindu.ojha on 5/06/23.
//

import XCTest
@testable import FairFaxMedia

final class ArticleUseCasesMock: ArticleUseCaseInteractor{
    func executeUseCaseGetArticleData() async -> Result<[FairFaxMedia.ArticleEntity], Error> {
        return .success([ArticleEntity()])
    }
    
    func executeUseCaseGetArticleImage(from url: String) async -> Result<Data?, Error> {
        let data: Data = "Test Data".data(using: .utf8)!
        return .success(data)
    }
}

final class AlertViewModelTests: XCTestCase {
    
    var sut: ArticleViewModel!
    var articleUseCaseInteractor: ArticleUseCaseInteractor!
   
    
    
    override func setUpWithError() throws {
        articleUseCaseInteractor = ArticleUseCasesMock()
        sut = ArticleViewModel(model: ArticleModel(), useCaseInteractor: articleUseCaseInteractor)
        
    }
    
    override func tearDownWithError() throws {
        articleUseCaseInteractor = nil
        sut = nil
    }
    
    func test_cache_data_storage(){
        // Arrange
        let url: String = "www.fakeurl.com"
        let data: Data = "Fake Data".data(using: .utf8)!
        
        // Act
        sut.storeImageDataInCache(data: data, imageUrl: url)
        let exp = expectation(description: "Test after 5 seconds")
        let _ = XCTWaiter.wait(for: [exp], timeout: 5.0)
        let dataFromcache = sut.getImageDataFromCache(imageUrl: url)
        
        //Assert
        XCTAssertEqual(dataFromcache, data)
    }
    
    func test_formatDate_return_longDatFormat_when_ticksProvided(){
        
        //Arrange
        let ticks = 1685519799000
        let expectedDate = "May 31, 2023"
        
        //Act
        let receivedDate = sut.formatDate(timeStamp: ticks)
        
        //Assert
        XCTAssertEqual(expectedDate, receivedDate)
    }
    
    func test_articleCellModel_create_articleCellModel_from_articleEntity(){
        // Arrange
       
        let articleEntity: ArticleEntity = ArticleEntity( articleURL: "urltoarticle1", headline: "headline1", abstract: "abstract1",author: "test1",
                           articleImages: [
                            ArticleImage(url: "url11", width: 32, height: 32, type: "thumbnail"),
                            ArticleImage(url: "url12", width: 132, height: 132, type: "landscape")
                           ], timeStamp: 1685519799000)
        
        //Act
        let cellModel = sut.createArticleCellModel(from: articleEntity)
        
        //Assert
        XCTAssertEqual(cellModel.timeStamp, 1685519799000)
        XCTAssertEqual(cellModel.localPublishTime!, "May 31, 2023")
    }
    
    func test_prepareDataForArticleView_returns_articleCellModels_from_articleEntities(){
        let articleEntities: [ArticleEntity] = [
            ArticleEntity( articleURL: "urltoarticle1", headline: "headline1", abstract: "abstract1",author: "test1",
                           articleImages: [
                            ArticleImage(url: "url11", width: 32, height: 32, type: "thumbnail"),
                            ArticleImage(url: "url12", width: 132, height: 132, type: "landscape")
                           ], timeStamp: 1685519799000),
            
            ArticleEntity( articleURL: "urltoarticle2", headline: "headline2", abstract: "abstract2",author: "test2",
                           articleImages: [
                            ArticleImage(url: "url21", width: 32, height: 32, type: "thumbnail"),
                            ArticleImage(url: "url22", width: 132, height: 132, type: "landscape")
                           ], timeStamp: 1685563200000),
            
        ]
        
        //Act
        let articleCellModels = sut.prepareDataForArticleView(articles: articleEntities)
        
        // Assert
        XCTAssertNotNil(articleCellModels)
        XCTAssertEqual(articleCellModels![0].timeStamp, 1685519799000)
    }
    
    func test_cellForAtRow_returns_cellModel_at_index(){
        //Arrange
        let articleCellModels: [ArticleCellModel] = [
            ArticleCellModel(articleURL: "url", headline: "headline", abstract: "abstract", author: "Test1", imageUrl: "fakeurl", timeStamp: 1685519799000, localPublishTime: "31 May, 2023"),
            ArticleCellModel(articleURL: "url", headline: "headline", abstract: "abstract", author: "Test1", imageUrl: "fakeurl", timeStamp: 1685563200000, localPublishTime: "1 June, 2023"),
            ]
            
        sut.articleCellModels = articleCellModels
        
        //Act

        let cell = sut.cellForAtRow(index: 0)
        
        //Assert
        XCTAssertEqual(cell.timeStamp, 1685519799000)
        
    }
    
    func test_cellForAtRow_returns_cellModelEmpty_at_invalidIndex(){
        //Arrange
        sut.articleCellModels = []
        let articleCellModels: [ArticleCellModel] = [
            ArticleCellModel(articleURL: "url", headline: "headline", abstract: "abstract", author: "Test1", imageUrl: "fakeurl", timeStamp: 1685519799000, localPublishTime: "31 May, 2023"),
            ArticleCellModel(articleURL: "url", headline: "headline", abstract: "abstract", author: "Test1", imageUrl: "fakeurl", timeStamp: 1685563200000, localPublishTime: "1 June, 2023"),
            ]
            
        sut.articleCellModels = articleCellModels
        
        //Act

        let cell = sut.cellForAtRow(index: 2)
        
        //Assert
        XCTAssertNil(cell.timeStamp)
        
    }
    
    
    
}
