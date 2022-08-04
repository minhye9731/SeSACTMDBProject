//
//  SearchCollectionViewCell.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/3/22.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var releaseDtLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var posterView: UIView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var linkIconButton: UIButton!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateNumberLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var castListLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var arrowButton: UIButton!
    
    
    func setCellData(indexPath: IndexPath, list: [TMDBModel]) {
        self.releaseDtLabel.text = list[indexPath.row].releaseDt
        self.rateNumberLabel.text = "\(list[indexPath.row].rate)"
        self.nameLabel.text = list[indexPath.row].name
        
        let url = URL(string: list[indexPath.row].posterImageView )
        self.posterImageView.kf.setImage(with: url)
        self.posterImageView.contentMode = .scaleAspectFill
        
        // 해당 영화에 출연한 배우 castlist 나타내기
        let programID = list[indexPath.row].id
//        self.castListLabel.text = castlist[indexPath.row][]
        
        
    }
    
    func configureLabel() {
        releaseDtLabel.font = .systemFont(ofSize: 14)
        releaseDtLabel.textColor = .systemGray2
        
        genreLabel.font = .boldSystemFont(ofSize: 18)
        genreLabel.textColor = .black
        
        nameLabel.font = .boldSystemFont(ofSize: 20)
        nameLabel.textColor = .black
        
        castListLabel.font = .boldSystemFont(ofSize: 14)
        castListLabel.textColor = .systemGray2
        
        detailLabel.text = "자세히 보기"
        detailLabel.font = .boldSystemFont(ofSize: 14)
        detailLabel.textColor = .darkGray
        
        rateLabel.text = "평점"
        rateLabel.font = .systemFont(ofSize: 14)
        rateLabel.textColor = .white
        rateLabel.backgroundColor = .systemIndigo
        rateLabel.textAlignment = .center
        
        rateNumberLabel.font = .systemFont(ofSize: 14)
        rateNumberLabel.textColor = .black
        rateNumberLabel.backgroundColor = .white
        rateNumberLabel.textAlignment = .center
    }
    
    func configureButton() {
        linkIconButton.setImage(UIImage(systemName: "paperclip"), for: .normal)
        linkIconButton.tintColor = .black
        linkIconButton.backgroundColor = .white
        linkIconButton.layer.cornerRadius = linkIconButton.bounds.height / 2
        
        arrowButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        arrowButton.tintColor = .darkGray
        arrowButton.backgroundColor = .clear
    }
    
    func configureView() {
        posterView.layer.cornerRadius = 8
//        posterView.clipsToBounds = true -> 주의! view자체의 boundary를 clip해버리면 그림자도 clip되어버림.
        
        // 대신 포스터 이미지의 상단양측도 깎아줌
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8
        posterImageView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        posterView.layer.shadowColor = UIColor.gray.cgColor
        posterView.layer.shadowOpacity = 1.0
        posterView.layer.shadowOffset = CGSize.zero
        posterView.layer.shadowRadius = 8
        
        
        
    }
    
    
}
