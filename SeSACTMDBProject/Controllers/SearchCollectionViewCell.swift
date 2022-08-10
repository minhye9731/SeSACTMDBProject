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
    
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateNumberLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var castListLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var arrowButton: UIButton!
    
    // 링크버튼 이벤트를 처리해줄 클로저 만들기
    var linkButtonAction : ( () -> Void) = {}
    
    func setCellData(type: Endpoint, indexPath: IndexPath, list: [TMDBModel], genre: GenreModel, cast: [Int : [Cast]]) {
        let digit: Double = pow(10, 1)
        let rateValue: Double = list[indexPath.row].rate
        let genreid: Int = list[indexPath.row].genreID
        
        self.releaseDtLabel.text = list[indexPath.row].releaseDt
        
        self.genreLabel.text = genre.genreDB[genreid]
        
        self.rateNumberLabel.text = "\(round(rateValue * digit) / digit)"
        self.nameLabel.text = list[indexPath.row].name
        
        let url = URL(string: type.requestURL + list[indexPath.row].posterImageView)
        self.posterImageView.kf.setImage(with: url)
        self.posterImageView.contentMode = .scaleAspectFill
        
        let programID = list[indexPath.row].id
        self.castListLabel.text = cast[programID]?.map { $0.name }.joined(separator: ", ")
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
        linkButton.setImage(UIImage(systemName: "paperclip"), for: .normal)
        linkButton.tintColor = .black
        linkButton.backgroundColor = .white
        linkButton.layer.cornerRadius = linkButton.bounds.height / 2
        // 링크버튼 클릭시 액션 설정
        linkButton.addTarget(self, action: #selector(showWebView), for: .touchUpInside)
        
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
    
    @objc
    func showWebView() {
        linkButtonAction()
    }
    
}
