//
//  WebViewController.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/10/22.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var programName: String = ""
    var destinationURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavi()
        
        DispatchQueue.main.async {
            self.openWebPage(url: self.destinationURL)
        }
    }
    
    func configureNavi() {
        
        self.navigationItem.title = "\(programName) 티저 보기"
    }
    
    func openWebPage(url: String) {
        guard let url = URL(string: destinationURL) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
