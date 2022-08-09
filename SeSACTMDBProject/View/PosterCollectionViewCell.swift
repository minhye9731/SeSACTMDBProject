//
//  PosterCollectionViewCell.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/9/22.
//

import UIKit

class PosterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterView: PosterView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    func setupUI() {
        posterView.backgroundColor = .systemGreen
        posterView.posterImageView.backgroundColor = .lightGray
        posterView.posterImageView.layer.cornerRadius = 10
    }

}
