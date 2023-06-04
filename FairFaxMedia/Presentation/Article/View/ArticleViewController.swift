//
//  ViewController.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 1/06/23.
//

import UIKit
import SafariServices

class ArticleViewController: UIViewController {
    
    let viewModel: ArticleViewModel
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //collectionView.backgroundColor = .red
        return collectionView
    }()
    
    private var navigationBarAppearance: UINavigationBarAppearance{
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .systemGray5
        navigationBarAppearance.shadowColor = .clear
        return navigationBarAppearance
    }
    
    init(viewModel: ArticleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray5
        setUpViews()
        fetchArticleData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        //configureNavigationBar(largeTitleColor: .white, backgroundColor: .systemGreen, tintColor: .white, title: "About Us", preferredLargeTitle: true)
    }
    
    func setUpViews(){
        //setupNavigationBar()
        setupCollectionView()
        
    }
    
    func setupNavigationBar() {
        
        navigationItem.title = "Fair Fax"
        //navigationItem.searchController = searchController
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        //self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setupCollectionView(){
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: "ArticleCollectionViewCell")
        self.view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    
    func fetchArticleData(){
        Task{
            await viewModel.getArticleData()
            await MainActor.run {
                collectionView.reloadData()
            }
        }
    }
}


extension ArticleViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.articleCellModels.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as? ArticleCollectionViewCell else {
            return UICollectionViewCell()
        }
        let cellForRow = viewModel.cellForAtRow(index: indexPath.row)
        cell.cellViewModel = cellForRow
        
        Task{
            cell.imageData = await viewModel.getArticleImage(index: indexPath.row)
        }
        
        return cell
    }
}

extension ArticleViewController: UICollectionViewDelegate{
    
    func loadWebpage(url: URL){
        let config = SFSafariViewController.Configuration()
        let safariViewController = SFSafariViewController(url: url, configuration: config)
        safariViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.present(safariViewController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let urlString = viewModel.articleCellModels[indexPath.row].articleURL, let url = URL(string: urlString) else {
            print("invalid url")
            return
        }
        loadWebpage(url: url)
       
    }
}

extension ArticleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

