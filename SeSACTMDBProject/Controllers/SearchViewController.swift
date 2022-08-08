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
import JGProgressHUD

class SearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var list : [TMDBModel] = []
    var genre : [Int: String] = [:]
    var castList : [Int : [[Cast]] ] = [ : ]
    var crewList : [Int : [[Crew]] ] = [ : ]
    
    var startPage = 1
    var totalCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavi()
        configureNaviBarButton()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
        collectionView.register(UINib(nibName: SearchCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier)
        
        configureLayout()
        fetchTVData()
        fetcgGenreData()
    }
    
// MARK: - Navi 설정
    func configureNavi() {
        self.navigationItem.title = "TREDY TV PROGRAMS"
        
        self.navigationController?.navigationBar.tintColor = .black
        
        let navibarAppearance = UINavigationBarAppearance()
        let barbuttonItemAppearance = UIBarButtonItemAppearance()
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navibarAppearance.backgroundColor = .white
        navibarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, .font: UIFont.boldSystemFont(ofSize: 20)]
        navibarAppearance.shadowColor = .gray
        
        self.navigationItem.scrollEdgeAppearance = navibarAppearance
        self.navigationItem.standardAppearance = navibarAppearance
        
        // searchController 만들어서 넣기!
        self.navigationItem.backBarButtonItem = backBarButton
        navibarAppearance.buttonAppearance = barbuttonItemAppearance
    }
    
    func configureNaviBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: ImageName.hamburgerMenu.rawValue), style: .plain, target: self, action: #selector(showSideMenu))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: ImageName.magnifyingGlass.rawValue), style: .plain, target: self, action: nil)
    }
    
    @objc
    func showSideMenu() {
        print("사이트 메뉴 보여주기")
        
        let sideVC = self.storyboard?.instantiateViewController(identifier: "SideMenuNavigationController")
        sideVC?.modalTransitionStyle = .coverVertical
        sideVC?.modalPresentationStyle = .pageSheet
        self.present(sideVC!, animated: true, completion: nil)
        
        
    }
    
// MARK: - API 통신 (TV 프로그램)
    func fetchTVData() {
        
        
        let url = EndPoint.tmdbURL + "api_key=\(APIKey.BOXOFFICE)&page=\(startPage)"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                self.totalCount = json["total_pages"].intValue

                for tv in json["results"].arrayValue {
                    
                    let imageUrl = EndPoint.imageURL + tv["poster_path"].stringValue
                    let releaseDt = tv["first_air_date"].stringValue
                    let rate = tv["vote_average"].doubleValue
                    let programName = tv["name"].stringValue
                    let overview = tv["overview"].stringValue
                    let id = tv["id"].intValue
                    let genreid = tv["genre_ids"][0].intValue
                    print("장르 1번째 : \(genreid)")
                    
                    let data = TMDBModel(releaseDt: releaseDt, genreID: genreid, posterImageView: imageUrl, rate: rate, name: programName, overview: overview, id: id)
                    
//                    self.fetchMemberData(id: id)
                    
                    self.list.append(data)
                    }
                
                
                self.collectionView.reloadData()
                
//                print(self.list)
                
            case .failure(let error):
                print(error)
            }
        
        }
        
    }
    
    // MARK: - API 통신 (genre)
    // 장르데이터를 통신으로 받아서 genre 딕셔너리에 담기
    func fetcgGenreData() {
        
        let url = EndPoint.genreURL + "api_key=\(APIKey.BOXOFFICE)&language=en-US"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for data in json["genres"].arrayValue {

                    let id = data["id"].intValue
                    let name = data["name"].stringValue

                    self.genre.updateValue(name, forKey: id)
                }

                print(self.genre)
//                self.collectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - API 통신 (cast, crew)
    func fetchMemberData(id: Int) {
        
        let url = EndPoint.memberURL +  "\(id)/credits?api_key=\(APIKey.BOXOFFICE)&language=en-US"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                // cast
                for cast in json["cast"].arrayValue {
                    
                    let realName = cast["name"].stringValue
                    let characterName = cast["character"].stringValue
                    let profileUrl = EndPoint.imageURL + cast["profile_path"].stringValue

                    let cast = Cast(name: realName, character: characterName, profilePath: profileUrl)
                    
                    
                    
//                    self.castList[id] = [cast]
                }
                
                // crew
                
                
                
                self.collectionView.reloadData()
                
//                print(self.castList)
                
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    
}

// MARK: - 페이지네이션
extension SearchViewController:  UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if list.count - 1 == indexPath.item && list.count < totalCount {
                startPage += 1 // display 몇 개 하냐에 따라 더해주는 숫자는 다름
//                fetchImage(query: searchBar.text!)
                fetchTVData()
            }
        }
        print("===\(indexPaths)") // 어떤 셀을 미리 준비시키는 것을 알 수 있음
    }
    
    // 취소: 직접 취소하는 기능을 구현해야 함
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("===실패\(indexPaths)")
    }

}



// MARK: - collectionView 설정

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.reuseIdentifier, for: indexPath) as? SearchCollectionViewCell else { return SearchCollectionViewCell() }
        
        item.setCellData(indexPath: indexPath, list: list, genre: genre)
        
        item.configureLabel()
        item.configureButton()
        item.configureView()
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 데이터도 갖고가
        
        
        // 상세화면으로 이동
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: DetailViewController.reuseIdentifier) as! DetailViewController
        
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
}

// MARK: - collectionView FlowLayout

extension SearchViewController {
    
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
}
