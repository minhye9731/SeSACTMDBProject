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
    
    var list2 : [TMDBModel] = []
    var row: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavi()
        configureProfile(row: row)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(OverViewTableViewCell.self, forCellReuseIdentifier: OverViewTableViewCell.reuseIdentifier)

        tableView.register(MemberTableViewCell.self, forCellReuseIdentifier: MemberTableViewCell.reuseIdentifier)
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
    func configureProfile(row: Int) {
        nameLabel.text = list2[row].name
        nameLabel.textColor = .white
        nameLabel.font = .boldSystemFont(ofSize: 24)
        
        let backURL = URL(string: list2[row].backdropImageView)
        backdropImageView.kf.setImage(with: backURL)
        backdropImageView.contentMode = .scaleAspectFill
        
        let profileURL = URL(string: list2[row].posterImageView)
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
            return 2 // cast number
        } else {
            return 2 //  crew number
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let overViewCell = tableView.dequeueReusableCell(withIdentifier: OverViewTableViewCell.reuseIdentifier, for: indexPath) as! OverViewTableViewCell
            
            overViewCell.overViewLabel?.text = "test입니다." // test
            return overViewCell
        } else if indexPath.section == 1 {
            // membercell에 CAST 정보 넣기
            let castCell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.reuseIdentifier, for: indexPath) as! MemberTableViewCell
            
            castCell.profileImageView?.tintColor = .blue // test
            castCell.memberNameLabel?.text = "공유" // test
            castCell.memberDetailLabel?.text = "도깨비" // test
            return castCell
        } else {
            // membercell에 CREW 정보 넣기
            let crewCell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.reuseIdentifier, for: indexPath) as! MemberTableViewCell
            
            crewCell.profileImageView?.tintColor = .red // test
            crewCell.memberNameLabel?.text = "홍길동" // test
            crewCell.memberDetailLabel?.text = "감독" // test
            return crewCell
        }
    }
    
}
