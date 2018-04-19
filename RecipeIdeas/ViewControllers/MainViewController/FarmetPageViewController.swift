//
//  FarmetPageViewController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 4/16/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

final class FarmetPageViewController: UIPageViewController, UINavigationBarDelegate {
    
    // MARK: - Properties
    lazy fileprivate var orderedViewControllers: [UIViewController] = {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        
        guard let firstVC = sb.instantiateViewController(withIdentifier: "FirstViewController") as? HomeViewController, let findFarmersMarketVC = sb.instantiateViewController(withIdentifier: "FindFarmersMarketViewController") as? FindFarmersMarketViewController,
            let whatsInSeasonVC = sb.instantiateViewController(withIdentifier: "WhatsInSeasonViewController") as? WhatsInSeasonViewController,
            let findSeasonalRecipesVC = sb.instantiateViewController(withIdentifier: "FindSeasonalRecipesViewController") as? FindSeasonalRecipesViewController else { return [UIViewController()] }
        return [firstVC,
                findFarmersMarketVC,
                whatsInSeasonVC,
                findSeasonalRecipesVC]
    }()
    
    lazy fileprivate var pageControl: UIPageControl! = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.tintColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        pageControl.pageIndicatorTintColor = .white
        
        return pageControl
    }()
    
    private func setupPageControl() {
        view.addSubview(pageControl)
        pageControl.numberOfPages = orderedViewControllers.count
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -UIScreen.main.bounds.height*(1/3) + 20)
            ])
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
}

extension FarmetPageViewController: UIPageViewControllerDelegate {
    
    // MARK: - PageViewController Delegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let pageContentViewController = pageViewController.viewControllers?[0] else { return }
        guard let currentPage = orderedViewControllers.index(of: pageContentViewController) else { return }
        pageControl.currentPage = currentPage
    }
}

extension FarmetPageViewController: UIPageViewControllerDataSource {
    
    // MARK: - PageViewController DataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let vCS = pageViewController.viewControllers
        let topVC:UIViewController? = vCS?[0]
        
        guard var index = orderedViewControllers.index(of: topVC!) else { return UIViewController() }
        if index >= 1 && index <= 3 {
            index -= 1
            let nextVC: UIViewController? = orderedViewControllers[index]
            return nextVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vCS = pageViewController.viewControllers
        let topVC:UIViewController? = vCS?[0]
        
        
        guard var index = orderedViewControllers.index(of: topVC!) else { return UIViewController() }
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
