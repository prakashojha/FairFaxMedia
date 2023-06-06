//
//  ViewController.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 1/06/23.
//

import UIKit
import SafariServices


 
 //A class to load data from Network and display it in a collection view
 
class ArticleViewController: UIViewController {
    
    /// An ArticleViewModel to provide data to ArticleViewController
    let viewModel: ArticleViewModel
    
    
    /// A vertical collection view to display data received from network
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    
    /// Used to set the appearance of the navigation bar.
    private var navigationBarAppearance: UINavigationBarAppearance{
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .systemGray5
        navigationBarAppearance.shadowColor = .clear
        return navigationBarAppearance
    }
    
    /// initialiser
    /// - Parameter viewModel: `ArticleViewModel`
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
    }
    
    func setUpViews(){
        setupCollectionView()

    }
    
    /// Navigation bar setup. Set title and appearance with large title
    func setupNavigationBar() {
        
        navigationItem.title = viewModel.navigationTitle
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    
    /// Collection view is set with constraints. `ArticleCollectionViewCell` is registered with collection view to act as a cell.
    func setupCollectionView(){
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //register a cell with collection view
        collectionView.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: viewModel.cellReuseIdentifier)
        self.view.addSubview(collectionView)
        
        /// Set constraints to match the safe area layout guide
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    
    /// Fetch articles asynchronously over the network
    /// Reload collection view on main thread after data is available.
    func fetchArticleData(){
        Task{
            await viewModel.getArticleData()
            await MainActor.run {
                collectionView.reloadData()
            }
        }
    }
}

//MARK: extension to implement UICollectionViewDataSource
extension ArticleViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.articleCellModels.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.cellReuseIdentifier, for: indexPath) as? ArticleCollectionViewCell else {
            return UICollectionViewCell()
        }
        let cellForRow = viewModel.cellForAtRow(index: indexPath.row)
        cell.cellViewModel = cellForRow
        
        ///Image is loaded asynchronously and added to cell image data on main thread
        Task{
            let imageData = await viewModel.getArticleImage(index: indexPath.row)
            await MainActor.run {
                cell.imageData = imageData
            }
        }
        
        return cell
    }
}

//MARK: extension to implement UICollectionViewDelegate
extension ArticleViewController: UICollectionViewDelegate{
    
    
    /// Load webpage in safari when a cell is tapped in collection view
    /// - Parameter url: url to be loaded
    func loadWebpage(url: URL){
        let config = SFSafariViewController.Configuration()
        let safariViewController = SFSafariViewController(url: url, configuration: config)
        safariViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.present(safariViewController, animated: true, completion: nil)
    }
    
    /// loads webpage in safari when a cell is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let urlString = viewModel.articleCellModels[indexPath.row].articleURL, let url = URL(string: urlString) else {
            return
        }
        loadWebpage(url: url)
    }
}

//MARK: extension to implement UICollectionViewDelegateFlowLayout
extension ArticleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(viewModel.minimumLineSpacingForSection)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

