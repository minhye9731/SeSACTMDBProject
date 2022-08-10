//
//  ListViewController.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/9/22.
//

import UIKit
import Kingfisher

class ListViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!

//    var similarTVListName: [[String]] = [[]]
    var similarTVList: [[String]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        mainTableView.backgroundColor = .clear
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        TMDBAPIManager.shared.requestImage { value in
            //1. 네트워크 통신 2.배열 생성 3. 배열 담기 4. 뷰 등에 표현
            // 뷰 갱신!
            self.similarTVList = value
            self.mainTableView.reloadData()
            print(self.similarTVList)
        }
    }
}


// MARK: - tableview 설정
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return similarTVList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(#function)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .clear
        cell.titleLabel.text = "\(TMDBAPIManager.shared.originTVShowList[indexPath.section].0) 와 비슷한 프로그램"
        
        cell.contentCollectionView.backgroundColor = .clear
        cell.titleLabel.textColor = .white
        cell.contentCollectionView.delegate = self
        cell.contentCollectionView.dataSource = self
        cell.contentCollectionView.tag = indexPath.section // 각 셀 구분 짓기!
        cell.contentCollectionView.register(UINib(nibName: "PosterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PosterCollectionViewCell")
        
        cell.titleLabel.tag = indexPath.section // 타이틀 레이블에도 테그를 줘봄

        cell.contentCollectionView.reloadData() // 인덱스 오류 해결책
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}

// MARK: - collectionview 설정

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarTVList[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCollectionViewCell", for: indexPath) as? PosterCollectionViewCell else { return UICollectionViewCell() }
        
        cell.posterView.backgroundColor = .clear
        cell.posterView.posterImageView.backgroundColor = .black
        cell.posterView.posterImageView.contentMode = .scaleAspectFill
        cell.posterView.contentLabel.textColor = .white
        
        let url = URL(string: "\(TMDBAPIManager.shared.imageURL)\(similarTVList[collectionView.tag][indexPath.item])")
        cell.posterView.posterImageView.kf.setImage(with: url)
        
        cell.posterView.contentLabel.text = ""
        
        return cell
    }
}
