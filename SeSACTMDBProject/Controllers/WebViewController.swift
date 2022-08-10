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
    
    var destinationURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openWebPage(url : destinationURL)
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
