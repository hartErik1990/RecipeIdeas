//
//  WebViewController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 2/27/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {

    // MARK: - Properties
    var urlString: String?
    
    @IBOutlet private weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWebView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func updateWebView() {
        DispatchQueue.main.async { [weak self] in
            guard let urlString = self?.urlString else {return}
            let newUrl = URL(string: urlString)
            guard let url = newUrl else {return}
            let request = URLRequest(url: url)
            self?.webView.load(request)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
