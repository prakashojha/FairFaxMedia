//
//  ArticleViewModel.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

class ArticleViewModel{
    
    /// Used to cash the image data
    private let cachedImage = NSCache<NSString, NSData>()
    /// model to keep data for view model
    private var model: ArticleModel
    /// A protocol adopted and confirmed by Domain layer. Used to call the use cases implemented by Domain Layer.
    let useCaseInteractor: ArticleUseCaseInteractor
    
    init(model: ArticleModel, useCaseInteractor: ArticleUseCaseInteractor){
        self.model = model
        self.useCaseInteractor = useCaseInteractor
    }
    
    /// Sets the number of section in collection view layout
    let numberOfSections: Int = 1
    
    ///  Sets the name for the reuse identifier to make cells recyclable
    let cellReuseIdentifier: String = "ArticleCollectionViewCell"
    
    ///  Set spacing between two cells
    let minimumLineSpacingForSection: Int = 5
    
    /// Tile of the navigation bar
    let navigationTitle: String = "FairFax Media"
    
    /// Collection of data required by Collection View Cell to display.  Data in this array maps directly with the index of CollectionViewCell
    var articleCellModels: [ArticleCellModel]{
        set{
            model.articleCellModels = newValue
        }
        get{
            return model.articleCellModels
        }
    }
    
    
    /// Retrieve Image data from cache. Returns nil if data not found.
    /// - Parameter imageUrl: an url used as key while storing data in cache
    /// - Returns: Returns data if retrieved from cache, return nil otherwise
    func getImageDataFromCache(imageUrl: String)->Data?{
        return cachedImage.object(forKey: NSString(string: imageUrl)) as? Data
    }
    
    
    ///  Stores  Image data in cache
    /// - Parameters:
    ///   - data: Image data in `Data` format
    ///   - imageUrl: a url to be used as a key
    func storeImageDataInCache(data: Data, imageUrl: String){
        self.cachedImage.setObject(data as NSData, forKey: NSString(string: imageUrl))
    }
    
    
    /// Retrieve article from asynchronously from a network call
    /// Network call is made via domain layer.
    /// On successful retrieval, data is prepared as per the requirement of the View cell.
    /// On failure, relevant message is passed down to view (Currently error is printed in console)
    func getArticleData() async{
        let result: Result<[ArticleEntity], Error> = await useCaseInteractor.executeUseCaseGetArticleData()
        switch(result){
        case .success(let articleEntities):
            if let articleList = prepareDataForArticleView(articles: articleEntities){
                self.articleCellModels = articleList
                sortArticleCellData(articleCellModels: &self.articleCellModels)
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    /// Retrieve image asynchronously from a network call.
    /// Successful retrieval returns data and stores it in Cache where imageURL is used as key.
    /// On failure prints error message in console
    /// - Parameter index: used to get imageURL from array `articleCellModels`
    /// - Returns: On Success returns Data
    func getArticleImage(index: Int) async -> Data?{
        var imageData: Data?
        guard let imageUrl = self.articleCellModels[index].imageUrl else { return imageData}
        if let data = getImageDataFromCache(imageUrl: imageUrl){
            imageData = data
        }
        else{
            let result: Result<Data?, Error> = await useCaseInteractor.executeUseCaseGetArticleImage(from: imageUrl)
            switch(result){
            case .success(let data):
                if let data = data {
                    self.storeImageDataInCache(data: data, imageUrl: imageUrl)
                }
                imageData = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return imageData
    }
    
    /// Format given ticks to Long Date Style. Timezone is set to `Australia/Sydney`
    /// - Parameter timeStamp: total ticks
    /// - Returns: Long date style e.g. `1 Jun 2023`
    func formatDate(timeStamp: Int?) -> String?{
        guard let timeStamp = timeStamp else { return nil }
        let timeInterval = TimeInterval(Double(timeStamp))
        let date = Date(timeIntervalSince1970: timeInterval / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeZone = TimeZone(identifier: "Australia/Sydney")
        return dateFormatter.string(from: date)
    }
    
    /// Prepares data for Collection View . Every item in `ArticleCellModel` correspond to the view of a cell in collection view.
    /// One to one mapping exists between `ArticleCellModel` array and Collection View Cell
    /// - Parameter articles: array of entities passed down from Domain layer
    /// - Returns: array of models for Collection view cell
    func prepareDataForArticleView(articles: [ArticleEntity]) -> [ArticleCellModel]?{
        var articleCellData: [ArticleCellModel] = []
        articles.forEach { article in
            let cellModel = createArticleCellModel(from: article)
            articleCellData.append(cellModel)
        }
        //articleCellData.sort{ $0.timeStamp! > $1.timeStamp! }
        return articleCellData
    }
    
    /// Sort cellModel data in ascending order
    /// - Parameter articleCellModels: array containing `ArticleCellModel`
    func sortArticleCellData(articleCellModels: inout [ArticleCellModel]){
        articleCellModels.sort{ $0.timeStamp! > $1.timeStamp! }
    }
    
    /// Create item for a single cell in collection view.
    /// - Parameter articleEntity: an entity model
    /// - Returns: a model for collection view cell
    func createArticleCellModel(from articleEntity: ArticleEntity) -> ArticleCellModel{
        var cellModel = ArticleCellModel()
        cellModel.articleURL = articleEntity.articleURL
        cellModel.headline = articleEntity.headline
        cellModel.abstract = articleEntity.abstract
        cellModel.author = articleEntity.author
        cellModel.imageUrl = articleEntity.articleImages?.first(where: { $0.type == "thumbnail"})?.url ?? ""
        cellModel.timeStamp = articleEntity.timeStamp
        cellModel.localPublishTime = formatDate(timeStamp: articleEntity.timeStamp)
        
        return cellModel
    }
    
    /// Returns a model from `articleCellModels` array for given index. Index must be  a valid number.
    /// - Parameter index: index for array
    /// - Returns: model for cell
    func cellForAtRow(index: Int)->ArticleCellModel{
        if index >= 0 && index < model.articleCellModels.count{
            return model.articleCellModels[index]
        }
        return ArticleCellModel()
    }
}
