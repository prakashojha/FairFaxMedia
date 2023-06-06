//
//  AlertViewCell.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    
    var cellViewModel: ArticleCellModel?{
        didSet{
            Task { @MainActor in
                self.headLine.text = cellViewModel?.headline
                self.abstract.text = cellViewModel?.abstract
                self.author.text = cellViewModel?.author
                self.publishedAt.text = cellViewModel?.localPublishTime
            }
        }
    }
    
    var imageData: Data?{
        didSet{
            if let imageData = imageData{
                Task { @MainActor in
                    self.imageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 0
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var headLine: UILabel = {
        let headLine = UILabel()
        headLine.numberOfLines = 0
        headLine.textAlignment = .left
        headLine.font = UIFont.systemFont(ofSize: 25, weight: .black)
        headLine.textColor = .white
        return headLine
    }()
    
    private lazy var abstract: UILabel = {
        let abstract = UILabel()
        abstract.numberOfLines = 3
        abstract.textAlignment = .left
        abstract.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        abstract.textColor = .white
        abstract.layer.zPosition = 2
        abstract.lineBreakMode = .byTruncatingTail
        return abstract
    }()
    
    private lazy var author: UILabel = {
        let author = UILabel()
        author.numberOfLines = 0
        author.textAlignment = .right
        author.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        author.textColor = .white
        return author
    }()
    
    private lazy var publishedAt: UILabel = {
        let publishedAt = UILabel()
        publishedAt.numberOfLines = 0
        publishedAt.textAlignment = .right
        publishedAt.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        publishedAt.textColor = .white
        return publishedAt
    }()
    
    private lazy var transparentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        self.addSubview(imageView)
        imageView.addSubview(transparentView)
        transparentView.addSubview(headLine)
        transparentView.addSubview(abstract)
        transparentView.addSubview(author)
        transparentView.addSubview(publishedAt)
        imageView.layer.cornerRadius = 15
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    func setupConstraints(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        transparentView.translatesAutoresizingMaskIntoConstraints = false
        headLine.translatesAutoresizingMaskIntoConstraints = false
        abstract.translatesAutoresizingMaskIntoConstraints = false
        author.translatesAutoresizingMaskIntoConstraints = false
        publishedAt.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
            transparentView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 0),
            transparentView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 0),
            transparentView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0),
            transparentView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
            
            headLine.topAnchor.constraint(equalTo: transparentView.topAnchor, constant: 15),
            headLine.leadingAnchor.constraint(equalTo: transparentView.leadingAnchor, constant: 15),
            headLine.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor, constant: -15),
            
            author.leadingAnchor.constraint(equalTo: transparentView.leadingAnchor, constant: 15),
            author.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor, constant: -15),
            author.bottomAnchor.constraint(equalTo: transparentView.bottomAnchor, constant: -15),
            author.heightAnchor.constraint(equalToConstant: 25),
            
            publishedAt.leadingAnchor.constraint(equalTo: transparentView.leadingAnchor, constant: 15),
            publishedAt.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor, constant: -15),
            publishedAt.bottomAnchor.constraint(equalTo: author.topAnchor, constant: -1),
            publishedAt.heightAnchor.constraint(equalToConstant: 15),

            abstract.bottomAnchor.constraint(equalTo: publishedAt.topAnchor, constant: -25),
            abstract.leadingAnchor.constraint(equalTo: transparentView.leadingAnchor, constant: 15),
            abstract.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor, constant: -15),

        ])
    }
}
