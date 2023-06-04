//
//  ArticleViewModel.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

class ArticleViewModel{
    
    let model: ArticleModel
    let useCaseInteractor: ArticleUseCaseInteractor
    
    init(model: ArticleModel, useCaseInteractor: ArticleUseCaseInteractor){
        self.model = model
        self.useCaseInteractor = useCaseInteractor
        getArticleData()
    }
    
    func getArticleData(){
        
        
    }
    
}
