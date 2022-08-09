//
//  DetailViewController.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/4/22.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var list2: [TMDBModel] = []
    var row: Int = 0
    var castList2: [Int : [Cast] ] = [:]
    var crewList2: [Int : [Crew] ] = [:]
    
    var castDataArray: [Cast] = []
    var crewDataArray: [Crew] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavi()
        configureProfile(type: .image, row: row)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: OverViewTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: OverViewTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: MemberTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MemberTableViewCell.reuseIdentifier)

    }
    
    // MARK: - Navi 설정
    func configureNavi() {
        self.navigationItem.title = "출연/제작"
        
        self.navigationController?.navigationBar.tintColor = .black
        
        let navibarAppearance = UINavigationBarAppearance()

        navibarAppearance.backgroundColor = .white
        navibarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, .font: UIFont.boldSystemFont(ofSize: 20)]
        navibarAppearance.shadowColor = .gray
        
        self.navigationItem.scrollEdgeAppearance = navibarAppearance
        self.navigationItem.standardAppearance = navibarAppearance
    }
    
    // MARK: - 프로필 화면 설정
    func configureProfile(type: Endpoint, row: Int) {
        nameLabel.text = list2[row].name
        nameLabel.textColor = .white
        nameLabel.font = .boldSystemFont(ofSize: 24)
        
        let backURL = URL(string: type.requestURL + list2[row].backdropImageView)
        backdropImageView.kf.setImage(with: backURL)
        backdropImageView.contentMode = .scaleAspectFill
        
        let profileURL = URL(string: type.requestURL + list2[row].posterImageView)
        posterImageView.kf.setImage(with: profileURL)
        posterImageView.contentMode = .scaleAspectFill
    }
}

// MARK: - tableview 설정
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "OverView"
        } else if section == 1 {
            return "Cast"
        } else {
            return "Crew"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return castDataArray.count
        } else {
            return crewDataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let overViewCell = tableView.dequeueReusableCell(withIdentifier: OverViewTableViewCell.reuseIdentifier, for: indexPath) as! OverViewTableViewCell
            
            overViewCell.overViewLabel?.text = list2[row].overview
            
            return overViewCell
        } else if indexPath.section == 1 {
            let castCell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.reuseIdentifier, for: indexPath) as! MemberTableViewCell
            
            castCell.setCastData(data: castDataArray[indexPath.row], type: .image)
            
            return castCell
        } else {
            // membercell에 CREW 정보 넣기
            let crewCell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.reuseIdentifier, for: indexPath) as! MemberTableViewCell
            
            crewCell.profileImageView.backgroundColor = .red // test
            crewCell.memberNameLabel?.text = "홍길동" // test
            crewCell.memberDetailLabel?.text = "감독" // test
            return crewCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 200 : 100
    }
    
}
