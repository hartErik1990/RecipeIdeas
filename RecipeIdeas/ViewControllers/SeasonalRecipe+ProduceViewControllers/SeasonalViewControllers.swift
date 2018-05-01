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
    
    @IBOutlet weak var winterProduceImage: UIImageView!
    
    @IBOutlet weak var winterRecipeImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(view.frame)
        print("*******")
        print(winterProduceImage.frame)
        print("*******")
        print(winterRecipeImage.frame)
        scrollView.setContentViewSize()
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.setContentOffset(CGPoint(x: 0, y: -45), animated: false)
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

extension UIScrollView{
    func setContentViewSize(offset:CGFloat = 0.0) {
        // dont show scroll indicators
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        var maxHeight : CGFloat = 0
        for view in subviews {
            if view.isHidden {
                continue
            }
            let newHeight = view.frame.origin.y + view.frame.height
            if newHeight > maxHeight {
                maxHeight = newHeight
            }
        }
        // set content size
        contentSize = CGSize(width: contentSize.width, height: maxHeight + offset)
        // show scroll indicators
        showsHorizontalScrollIndicator = true
        showsVerticalScrollIndicator = true
    }
}
