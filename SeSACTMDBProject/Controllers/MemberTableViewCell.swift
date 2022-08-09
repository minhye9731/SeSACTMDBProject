//
//  MemberTableViewCell.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/6/22.
//

import UIKit

import Kingfisher

class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLabel()
    }
    
    func configureLabel() {
        profileImageView.backgroundColor = .clear
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 8
        
        memberNameLabel.textColor = .black
        memberNameLabel.font = .boldSystemFont(ofSize: 18)
        memberDetailLabel.textColor = .systemGray4
        memberDetailLabel.font = .boldSystemFont(ofSize: 14)
    }
    
    func setCastData(data: Cast, type: Endpoint) {
        memberNameLabel.text = data.name
        memberDetailLabel.text = data.character
        
        let urlString = data.profilePath != nil ? (type.requestURL + data.profilePath!) : "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Unknown_person.jpg/694px-Unknown_person.jpg"
        
        guard let profileURL = URL(string: urlString) else { return }
        
        profileImageView.kf.setImage(with: profileURL)
    }
    
    func setCrewData(data: Crew, type: Endpoint) {
        memberNameLabel.text = data.name
        memberDetailLabel.text = "\(data.department) / \(data.job)"
        
        let urlString = data.profilePath != nil ? (type.requestURL + data.profilePath!) : "https://icon-library.com/images/unknown-person-icon/unknown-person-icon-4.jpg"
        
        guard let profileURL = URL(string: urlString) else { return }
        
        profileImageView.kf.setImage(with: profileURL)
        // 아무도없을때 기본이미지 설정 재확인 및 수정 필요
    }
    
}
