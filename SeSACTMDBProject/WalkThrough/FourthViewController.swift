//
//  FourhViewController.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/17/22.
//

import UIKit

class FourthViewController: UIViewController {

    @IBOutlet weak var fourthTutorialLabel: UILabel!
    @IBOutlet weak var fourthSampleScene: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setTutorialLabel(label: fourthTutorialLabel, title: """
        기대되는 TV 프로그램의
        티저까지 볼 수 있어요 :)
        """)
        setSampleScene(imgView: fourthSampleScene, name: "screenshot4")

        setTutorialAnimate(dur: 1, label: fourthTutorialLabel, imgView: fourthSampleScene)
        
        startButton.configuration = .tutorialStyle()
    }
    
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        
        print("첫 메인화면으로 이동!")
        
        UserDefaults.standard.set(true, forKey: "FirstRun")
//        UserDefaults.standard.synchronize() // 정의 설명에는 필요없고 쓰지 말아야 한다는데?
        
        // 현재 이 화면을 지우고, 메인화면으로 돌아가자
        self.presentingViewController?.dismiss(animated: true)
    }
    
    
}
