//
//  OnboardingViewControllers.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 4/16/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

final class FindFarmersMarketViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

final class WhatsInSeasonViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

final class FindSeasonalRecipesViewController: UIViewController {
    
    @IBOutlet weak var letsGoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        letsGoButton.pulsate()
    }
}



