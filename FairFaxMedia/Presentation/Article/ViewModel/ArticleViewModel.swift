//
//  ArticleViewModel.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

class ArticleViewModel{
    
    private let cachedImage = NSCache<NSString, NSData>()
    private var model: ArticleModel
    let useCaseInteractor: ArticleUseCaseInteractor
    
    init(model: ArticleModel, useCaseInteractor: ArticleUseCaseInteractor){
        self.model = model
        self.useCaseInteractor = useCaseInteractor
    }
    
    var articleCellModels: [ArticleCellModel]{
        set{
            model.articleCellModels = newValue
        }
        get{
            return model.articleCellModels
        }
    }
    
    func getImageDataFromCache(imageUrl: String)->Data?{
        return cachedImage.object(forKey: NSString(string: imageUrl)) as? Data
    }
    
    func storeImageDataInCache(data: Data, imageUrl: String){
        self.cachedImage.setObject(data as NSData, forKey: NSString(string: imageUrl))
    }
    
    func getArticleData() async{
        let result: Result<[ArticleEntity], Error> = await useCaseInteractor.executeUseCaseGetArticleData()
        switch(result){
        case .success(let articleEntities):
            if let articleList = prepareDataForArticleView(articles: articleEntities){
                self.articleCellModels = articleList
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
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
    
    func formatDate(timeStamp: Int?) -> String?{
        guard let timeStamp = timeStamp else { return nil }
        let timeInterval = TimeInterval(Double(timeStamp))
        let date = Date(timeIntervalSince1970: timeInterval / 1000)
        let dateFormater = DateFormatter()
        //dateFormater.timeStyle = .short
        dateFormater.dateStyle = .long
        dateFormater.timeZone = TimeZone(identifier: "Australia/Sydney")
        return dateFormater.string(from: date)
       /// print(dateString)
    }
    
    func prepareDataForArticleView(articles: [ArticleEntity]) -> [ArticleCellModel]?{
        var articleCellData: [ArticleCellModel] = []
        articles.forEach { article in
            let cellModel = createArticleCellModel(from: article)
            articleCellData.append(cellModel)
        }
        articleCellData.sort{ $0.timeStamp! > $1.timeStamp! }
//        articleCellData.forEach{
//            formatDate(timeStamp: $0.timeStamp!)
//        }
        return articleCellData
    }
    
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
    
    func cellForAtRow(index: Int)->ArticleCellModel{
        if index >= 0 && index < model.articleCellModels.count{
            //print(index, model.articleCellModels[index].headline)
            return model.articleCellModels[index]
        }
        return ArticleCellModel()
    }
}
