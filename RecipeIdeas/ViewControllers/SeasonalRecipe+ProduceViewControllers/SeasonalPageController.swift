//
//  SeasonalPageController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 4/16/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

final class SeasonalPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // MARK: - Properties
    lazy private var orderedViewControllers: [UIViewController] = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let winterVC = storyboard.instantiateViewController(withIdentifier: "WinterViewController") as? WinterViewController, let springVC = storyboard.instantiateViewController(withIdentifier: "SpringViewController") as? SpringViewController,
            let summerVC = storyboard.instantiateViewController(withIdentifier: "SummerViewController") as? SummerViewController,
            let fallVC = storyboard.instantiateViewController(withIdentifier: "FallViewController") as? FallViewController else { return [UIViewController()] }
        return [winterVC,
                springVC,
                summerVC,
                fallVC]
    }()
    
    lazy private var pageControl: UIPageControl! = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.tintColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        pageControl.alpha = 0.5
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        pageControl.pageIndicatorTintColor = .white
        
        return pageControl
    }()
    
    private func setupPageControl() {
        view.addSubview(pageControl)
        pageControl.numberOfPages = orderedViewControllers.count
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        let safeLayoutView = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: safeLayoutView.bottomAnchor, constant: 0)
            ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        delegate = self
        dataSource = self
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        setupPageControl()
    }
    
    override func viewDidLayoutSubviews() {
        pageControl.transform = CGAffineTransform(scaleX: 2, y: 2)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let pageContentViewController = pageViewController.viewControllers?[0] else { return }
        guard let currentPage = orderedViewControllers.index(of: pageContentViewController) else { return }
        pageControl.currentPage = currentPage
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let arrayOfViewControllers = pageViewController.viewControllers else { return UIViewController() }
        let firstVC: UIViewController? = arrayOfViewControllers[0]
        guard var index = orderedViewControllers.index(of: firstVC!) else { return UIViewController() }
        if index >= 1 && index <= 3  {
            index -= 1
            let nextVC: UIViewController? = orderedViewControllers[index]
            return nextVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let arrayOfViewControllers = pageViewController.viewControllers else { return UIViewController() }
        let firstVC: UIViewController? = arrayOfViewControllers[0]
        
        guard var index = orderedViewControllers.index(of: firstVC!) else { return UIViewController() }
        if index >= 0 && index < 3 {
            index += 1
            if index == orderedViewControllers.count {
                return nil
            }
            let nextVC: UIViewController? = orderedViewControllers[index]
            return nextVC
        }
        return nil
    }
}
