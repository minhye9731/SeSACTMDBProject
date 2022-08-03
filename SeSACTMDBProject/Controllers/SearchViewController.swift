//
//  SearchViewController.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/3/22.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class SearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var list : [TMDBModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        configureLayout()
        
        collectionView.register(UINib(nibName: SearchCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier)
        
        fetchData()
    }
    
    func configureLayout() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: width, height: width * 1.3)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        collectionView.collectionViewLayout = layout
    }
    
    func fetchData() {
        
        let url = EndPoint.tmdbURL + "api_key=\(APIKey.BOXOFFICE)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)

                for tv in json["results"].arrayValue {
                    
                    let imageUrl = EndPoint.imageURL + tv["poster_path"].stringValue
                    let releaseDt = tv["first_air_date"].stringValue
                    let rate = tv["vote_average"].doubleValue
                    let programName = tv["name"].stringValue
                    let overview = tv["overview"].stringValue
                    // genre는 항목별 섹션 참고해서 구현
                    
                    let data = TMDBModel(releaseDt: releaseDt, genre: "00", posterImageView: imageUrl, rate: rate, name: programName, overview: overview)
                    
                        self.list.append(data)
                    }

                self.collectionView.reloadData()
                
                print(self.list)
                
            case .failure(let error):
                print(error)
            }
        
        }
        
    }
    
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.reuseIdentifier, for: indexPath) as? SearchCollectionViewCell else { return SearchCollectionViewCell() }
        
        item.setCellData(indexPath: indexPath, list: list)
        
        item.configureLabel()
        item.configureButton()
        item.configureView()
        
        return item
    }
    
}
