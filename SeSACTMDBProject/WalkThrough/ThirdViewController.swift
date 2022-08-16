//
//  ThirdViewController.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/17/22.
//

import UIKit

class ThirdViewController: UIViewController {

    @IBOutlet weak var thirdTutorialLabel: UILabel!
    @IBOutlet weak var thirdSampleScene: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setTutorialLabel(label: thirdTutorialLabel, title: """
        우리동네 근처
        영화관 위치까지 알 수 있어요!
        """)
        setSampleScene(imgView: thirdSampleScene, name: "screenshot3")

        setTutorialAnimate(dur: 1, label: thirdTutorialLabel, imgView: thirdSampleScene)
    }
}
