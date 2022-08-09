//
//  ListTableViewCell.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/9/22.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.backgroundColor = .red
        
        contentCollectionView.backgroundColor = .blue
        contentCollectionView.collectionViewLayout = collectionViewLayout()
    }

    // 포스터가 들어가는 collectionviewlayout에 대한 설정은 tableviewcell마다 들어가므로 여기서 설정해줌
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 130)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        return layout
    }
    
    

}
