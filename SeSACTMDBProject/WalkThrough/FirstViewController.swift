//
//  FirstViewController.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/17/22.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var firstTutorialLabel: UILabel!
    @IBOutlet weak var firstSampleScene: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        setTutorialLabel(label: firstTutorialLabel, title: """
        가장 핫한 TV 프로그램들을
        둘러보세요!
        """)
        setSampleScene(imgView: firstSampleScene, name: "screenshot1")

        setTutorialAnimate(dur: 1, label: firstTutorialLabel, imgView: firstSampleScene)
    }
}
