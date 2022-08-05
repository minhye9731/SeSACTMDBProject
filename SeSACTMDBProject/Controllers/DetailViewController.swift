//
//  DetailViewController.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/4/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavi()
        
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


    

}

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
        
        let overViewCell = tableView.dequeueReusableCell(withIdentifier: OverViewTableViewCell.reuseIdentifier, for: indexPath) as! OverViewTableViewCell
        let memberCell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.reuseIdentifier, for: indexPath) as! MemberTableViewCell
        
        if indexPath.section == 0 {
            overViewCell.overViewLabel?.text = "test입니다." // test
            return overViewCell
        } else if indexPath.section == 1 {
            // membercell에 CAST 정보 넣기
            memberCell.profileImageView?.tintColor = .blue // test
            memberCell.memberNameLabel?.text = "공유" // test
            memberCell.memberDetailLabel?.text = "도깨비" // test
            return memberCell
        } else {
            // membercell에 CREW 정보 넣기
            memberCell.profileImageView?.tintColor = .red // test
            memberCell.memberNameLabel?.text = "홍길동" // test
            memberCell.memberDetailLabel?.text = "감독" // test
            return memberCell
        }
    }
    
    
    
    
}
