//
//  PosterView.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/9/22.
//

import UIKit

class PosterView: UIView {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let view = UINib(nibName: "PosterView", bundle: nil).instantiate(withOwner: self).first as! UIView
        
        view.frame = bounds
        view.backgroundColor = .clear
        self.addSubview(view)
    }

}
