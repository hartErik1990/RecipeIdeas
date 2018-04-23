//
//  SeasonsViewControllers.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 4/16/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

final class WinterViewController: UIViewController {
    
    @IBOutlet weak private var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.setContentOffset(CGPoint(x: 0, y: -20), animated: false)
    }
}

final class SpringViewController: UIViewController {
    @IBOutlet weak private var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.setContentOffset(CGPoint.zero, animated: false)

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.setContentOffset(CGPoint.zero, animated: false)
    }
}

final class SummerViewController: UIViewController {
    
    @IBOutlet weak private var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.setContentOffset(CGPoint.zero, animated: false)

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.setContentOffset(CGPoint.zero, animated: false)
    }
}

final class FallViewController: UIViewController {
    
    @IBOutlet weak private var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.setContentOffset(CGPoint.zero, animated: false)

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.setContentOffset(CGPoint.zero, animated: false)
    }
}
