//
//  OverViewTableViewCell.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/6/22.
//

import UIKit

class OverViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    
    var expandButtonTapped : (() -> Void) = {}
//    var isExpanded = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLabel()
        configureButton()
    }
    
    func configureLabel() {
        overViewLabel.textColor = .black
        overViewLabel.font = .boldSystemFont(ofSize: 16)
    }
    
    func configureButton() {
        expandButton.tintColor = .darkGray
        expandButton.backgroundColor = .clear
        expandButton.addTarget(self, action: #selector(expandCell), for: .touchUpInside)
    }
    
    // MARK: - overview셀 확장여부 함수
    @objc func expandCell() {
        print("버튼 눌렸다!")
        expandButtonTapped()
    }
}
