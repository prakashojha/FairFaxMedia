//
//  ArticleDataRepo.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

protocol ArticleDataRepo{
    
    func getArticleData() async -> Result<[ArticleEntity], Error>
    func getArticleImage(from url: String) async -> Result<Data?, Error>
    
}
