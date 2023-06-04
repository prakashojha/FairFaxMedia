//
//  ArticleViewModel.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

class ArticleViewModel{
    
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
        if let imageUrl = self.articleCellModels[index].imageUrl{
            let result: Result<Data?, Error> = await useCaseInteractor.executeUseCaseGetArticleImage(from: imageUrl)
            switch(result){
            case .success(let data):
                imageData = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return imageData
    }
    
    func prepareDataForArticleView(articles: [ArticleEntity]) -> [ArticleCellModel]?{
        var articleCellData: [ArticleCellModel] = []
        articles.forEach { article in
            let cellModel = createArticleCellModel(from: article)
            articleCellData.append(cellModel)
        }
        return articleCellData
    }
    
    func createArticleCellModel(from articleEntity: ArticleEntity) -> ArticleCellModel{
        var cellModel = ArticleCellModel()
        cellModel.headline = articleEntity.headline
        cellModel.abstract = articleEntity.abstract
        cellModel.author = articleEntity.author
        cellModel.imageUrl = articleEntity.articleImages?.first(where: { $0.type == "thumbnail"})?.url ?? ""
        
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
