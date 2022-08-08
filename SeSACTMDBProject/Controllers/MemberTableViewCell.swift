//
//  MemberTableViewCell.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/6/22.
//

import UIKit

class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLabel()
    }
    
    func configureLabel() {
        
        profileImageView.tintColor = .systemPink
        profileImageView.layer.cornerRadius = 8
        
        memberNameLabel.textColor = .black
        memberNameLabel.font = .boldSystemFont(ofSize: 18)
        memberDetailLabel.textColor = .systemGray4
        memberDetailLabel.font = .boldSystemFont(ofSize: 14)
        
    }
    
}
