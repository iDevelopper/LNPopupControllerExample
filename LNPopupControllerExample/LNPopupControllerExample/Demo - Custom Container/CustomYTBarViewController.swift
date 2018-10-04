//
//  CustomYTBarViewController.swift
//  LNPopupControllerExample
//
//  Created by Patrick BODET on 04/10/2018.
//  Copyright © 2018 Leo Natan. All rights reserved.
//

import UIKit

class CustomYTBarViewController: LNPopupCustomBarViewController {
    @IBOutlet weak var barView: UIView!
    
    override var wantsDefaultPanGestureRecognizer: Bool {
        get {
            return false;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize = CGSize(width: -1, height: 65)
        
        self.view.preservesSuperviewLayoutMargins = true
        
        barView.layer.shadowColor = UIColor.black.cgColor
        barView.layer.shadowOpacity = 0.5
        barView.layer.shadowRadius = 5
        barView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        //barView.layer.cornerRadius = 2
    }
    
    override func popupItemDidUpdate() {
        //searchBar.text = containingPopupBar.popupItem?.title
    }
}
