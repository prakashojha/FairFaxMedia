//
//  ViewController.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 1/06/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        
        let url = "https://bruce-v2-mob.fairfaxmedia.com.au/1/coding_test/13ZZQX/full"
        let remoteNetworkService = RemoteNetworkService(urlString: url)
        
        let dataService: ArticleDataService = ArticleDataService(remoteNetworkService: remoteNetworkService)
        do{
            Task{
                try await dataService.getArticleData()
            }
        }
    }


}

