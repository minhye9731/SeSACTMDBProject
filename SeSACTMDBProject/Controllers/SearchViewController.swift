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
    
    var list: [TMDBModel] = []
    var genre = GenreModel.shared
    var castList: [Int : [Cast] ] = [:]
    var crewList: [Int : [Crew] ] = [:]
    var keyURLList: [Int : String ] = [:]
    
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
        
        fetchTVData(startPage: startPage)
        fetchGenreData()
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: ImageName.magnifyingGlass.rawValue), style: .plain, target: self, action: #selector(showListPage))
    }
    
    @objc
    func showSideMenu() {
        print("사이트 메뉴 보여주기")
        
        let sideVC = self.storyboard?.instantiateViewController(identifier: "SideMenuNavigationController")
        sideVC?.modalTransitionStyle = .coverVertical
        sideVC?.modalPresentationStyle = .pageSheet
        self.present(sideVC!, animated: true, completion: nil)
    }
    
    // 임시로 화면 이동 기능 넣음 (화면 확인 목적)
    @objc
    func showListPage() {
        print("ListViewController 페이지 보여주기")
        
        let listVC = self.storyboard?.instantiateViewController(identifier: "ListViewController")
        listVC?.modalTransitionStyle = .coverVertical
        listVC?.modalPresentationStyle = .pageSheet
        self.present(listVC!, animated: true, completion: nil)
    }

// MARK: - API 통신 (TV 프로그램)
    func fetchTVData(startPage: Int) {
        TMDBAPIManager.shared.fetchTVAPI(type: .trend, startPage: startPage) { totalCount, trendDataArray in
            
            self.totalCount = totalCount
            self.list.append(contentsOf: trendDataArray)
            
            self.fetchCreditsData(tvDT: self.list)
            self.fetchVideoKeyData(tvDT: self.list)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - API 통신 (genre)
    // 장르데이터를 통신으로 받아서 genre 딕셔너리에 담기
    func fetchGenreData() {
        TMDBAPIManager.shared.fetchGenreAPI(type: .genre) { json in
            
            for data in json["genres"].arrayValue {

                let id = data["id"].intValue
                let name = data["name"].stringValue

                self.genre.appendGenreDT(value: name, key: id)
            }

            self.collectionView.reloadData()
        }
    }
    
    // MARK: - API 통신 (cast, crew)
    func fetchCreditsData(tvDT: [TMDBModel]) {
        
        for program in 0..<(tvDT.count - 1) {
            
            TMDBAPIManager.shared.fetchCreditsAPI(type: .credits, tvDataID: tvDT[program].id) { castDataArray, crewDataArray in
                
                self.castList[tvDT[program].id] = castDataArray
                self.crewList[tvDT[program].id] = crewDataArray
            }
        }
    }
    
    // MARK: - API 통신 (프로그램별 영상 key값)
    func fetchVideoKeyData(tvDT: [TMDBModel]) {
        
        for program in 0..<(tvDT.count) {
            
            TMDBAPIManager.shared.fetchVideoAPI(type: .youtube, tvDataID: tvDT[program].id) { keyURLSting in
                
                self.keyURLList[tvDT[program].id] = keyURLSting
                print("키값들 : \(self.keyURLList)")
            }
        }
    }
    
    // MARK: - link버튼 클릭시 액션
//    @objc func linkButtonTapped(_ sender: UIButton) {
//
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let webVC = sb.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
//        webVC.modalTransitionStyle = .coverVertical
//        webVC.modalPresentationStyle = .pageSheet
//
//        webVC
//
//        self.navigationController?.pushViewController(webVC, animated: true)
//    }
    
    
}

// MARK: - collectionView 설정

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.reuseIdentifier, for: indexPath) as? SearchCollectionViewCell else { return SearchCollectionViewCell() }
        
        item.setCellData(type: .image, indexPath: indexPath, list: list, genre: genre, cast: castList)
        
        item.configureLabel()
        item.configureButton()
        item.configureView()
        
        item.linkButton.tag = indexPath.row
        
        // 클로저 구문으로 링크버튼 액션 구현!
        item.linkButtonTapped = {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let webVC = sb.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            webVC.modalTransitionStyle = .coverVertical
            webVC.modalPresentationStyle = .pageSheet
            
            webVC.destinationURL = self.keyURLList[self.list[indexPath.row].id]!
            
            self.navigationController?.pushViewController(webVC, animated: true)
        }
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: DetailViewController.reuseIdentifier) as! DetailViewController
        
        detailVC.list2 = list
        detailVC.castDataArray = castList[list[indexPath.row].id]!
        detailVC.crewDataArray = crewList[list[indexPath.row].id]!
        detailVC.row = indexPath.row
        
        self.navigationController?.pushViewController(detailVC, animated: true)
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

// MARK: - 페이지네이션
extension SearchViewController:  UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if list.count - 1 == indexPath.item && list.count < totalCount {
                startPage += 1 // display 몇 개 하냐에 따라 더해주는 숫자는 다름
//                fetchImage(query: searchBar.text!)
                fetchTVData(startPage: startPage)
            }
        }
        print("===\(indexPaths)") // 어떤 셀을 미리 준비시키는 것을 알 수 있음
    }
    
    // 취소: 직접 취소하는 기능을 구현해야 함
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("===실패\(indexPaths)")
    }
}
