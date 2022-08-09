//
//  OverViewTableViewCell.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/6/22.
//

import UIKit

class OverViewTableViewCell: UITableViewCell {
    @IBOutlet weak var overViewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLabel()
    }
    
    func configureLabel() {
        overViewLabel.textColor = .black
        overViewLabel.font = .boldSystemFont(ofSize: 16)
    }
}
