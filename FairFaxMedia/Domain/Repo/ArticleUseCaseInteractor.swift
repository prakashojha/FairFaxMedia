//
//  ArticleUseCaseInteractor.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

protocol ArticleUseCaseInteractor{
    func executeUseCaseGetArticleData() async -> Result<[ArticleEntity], Error>
    func executeUseCaseGetArticleImage(from url: String) async -> Result<Data?, Error>
}
