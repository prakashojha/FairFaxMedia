//
//  ViewController.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 1/06/23.
//

import UIKit

class ArticleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        
        let url = "https://bruce-v2-mob.fairfaxmedia.com.au/1/coding_test/13ZZQX/full"
        let remoteNetworkService = RemoteNetworkService(urlString: url)
        
        let dataService: ArticleDataService = ArticleDataService(remoteNetworkService: remoteNetworkService)
       
            Task{
                let result: Result<[ArticleEntity], Error> = await dataService.getArticleData()
                await MainActor.run {
                    switch(result){
                    case .success(let articleEntities):
                        print(articleEntities[0].articleImages?[0].url ?? "Nothing found")
                    case .failure(let error):
                        print(error.localizedDescription)
                        
                    }
                }
            }
        
    }


}

