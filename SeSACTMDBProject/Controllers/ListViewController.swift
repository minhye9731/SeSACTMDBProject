//
//  ListViewController.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/9/22.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    
    var headers = ["아는 와이프와 비슷한 콘텐츠", "미스터 선샤인과 비슷한 콘텐츠", "액션 SF", "미국TV프로그램"]
    
//    let numberList: [[Int]] = [
//        [Int](100...110),
//        [Int](55...75),
//        [Int](5000...5006),
//        [Int](81...90),
//        [Int](21...31)
//        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        mainTableView.backgroundColor = .clear
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
}


// MARK: - tableview 설정
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
//        return numberList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(#function)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .clear
        cell.contentCollectionView.backgroundColor = .clear // 왜 table cell 안에서 컬렉션뷰 셀 배경 정하고, 여기서 한번 더 하지??
        
        cell.contentCollectionView.delegate = self
        cell.contentCollectionView.dataSource = self
        cell.contentCollectionView.tag = indexPath.section // 섹션별 색상 다르게 설정하려고 tag를 준다. 각 셀 구분 짓기!
        cell.contentCollectionView.register(UINib(nibName: "PosterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PosterCollectionViewCell")
        
        cell.titleLabel.tag = indexPath.section // 타이틀 레이블에도 테그를 줘봄
        cell.titleLabel.text = "\(headers[indexPath.section])"
        
        
        
        // 인덱스 오류 해결책?
//        cell.contentCollectionView.reloadData()
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}

// MARK: - collectionview 설정

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 // 포스터 데이터 넣자
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCollectionViewCell", for: indexPath) as? PosterCollectionViewCell else { return UICollectionViewCell() }
        
        cell.posterView.posterImageView.backgroundColor = .black
        
        cell.posterView.posterImageView.image = UIImage(named: "겨울왕국2")
        cell.posterView.contentLabel.textColor = .white
//        cell.posterView.contentLabel.text = "\(numberList[collectionView.tag][indexPath.item])" // 에러해결 ㄴㄴ
        
        
        
        return cell
    }


}
