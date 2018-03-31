//
//  WebViewController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 2/27/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit
import WebKit

final class WebViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: - Properties
    var urlString: String?

    @IBOutlet private weak var webView: WKWebView!
   
    var progressView: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(urlString)
        updateWebView()
        self.webView.navigationDelegate = self
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeThatFits(CGSize(width: view.frame.size.width, height: 2))
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        //initializing the barWidth
        progressView.barWidth = 1
        navigationController?.navigationBar.addSubview(progressView)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    private func updateWebView() {
        DispatchQueue.main.async { [weak self] in
          
            guard let urlString = self?.urlString else { return }
            let newUrl = URL(string: urlString)
            guard let url = newUrl else { return }
            let request = URLRequest(url: url)
            self?.webView.load(request)
        }
    }
//
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if let host = navigationAction.request.url?.host {
//            if host.contains("\(String(describing: urlString))") {
//                decisionHandler(.allow)
//                return
//            } else {
//                decisionHandler(.cancel)
//            }
//        }
//    }

}

extension UIProgressView {

    var barWidth : CGFloat {
        get {
            return transform.d * 1.0
        }
        set {
            let c = center
            transform = CGAffineTransform(scaleX: 3.7, y: 1.0)
            center = c
        }
    }
}









