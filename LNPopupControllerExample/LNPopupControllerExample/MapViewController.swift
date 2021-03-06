//
//  MapViewController.swift
//  LNPopupControllerExample
//
//  Created by Leo Natan on 30/12/2016.
//  Copyright © 2016 Leo Natan. All rights reserved.
//

import LNPopupController
import UIKit
import MapKit

class MapViewController: UIViewController, UISearchBarDelegate {
	@IBOutlet weak var mapView: MKMapView!
	private var popupContentVC: LocationsController!
    
    var customMapBar: CustomYTBarViewController!

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        
        let targetVC: UIViewController = self.tabBarController ?? self
		
        customMapBar = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "CustomYTBarViewController") as! CustomYTBarViewController
        customMapBar.view.backgroundColor = .clear
        targetVC.popupBar.inheritsVisualStyleFromDockingView = false
        targetVC.popupBar.customBarViewController = customMapBar
        targetVC.popupContentView.popupCloseButtonStyle = .none
        targetVC.popupInteractionStyle = .snap
        /*
		let customMapBar = storyboard!.instantiateViewController(withIdentifier: "CustomMapBarViewController") as! CustomMapBarViewController
		customMapBar.view.backgroundColor = .clear
		customMapBar.searchBar.delegate = self
		
		popupBar.customBarViewController = customMapBar
		popupContentView.popupCloseButtonStyle = .none
		popupInteractionStyle = .snap
		*/
        popupContentVC = storyboard!.instantiateViewController(withIdentifier: "PopupContentController") as? LocationsController
		popupContentVC.tableView.backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
		
		DispatchQueue.main.async {
//			self.presentPopupBar(withContentViewController: self.popupContentVC, animated: false, completion: nil)
            targetVC.presentPopupBar(withContentViewController: self.popupContentVC, animated: false, completion: nil)
		}
	}
	
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_ context) in
            //
            if size.width > size.height {
                self.customMapBar.preferredContentSize = CGSize(width: -1, height: 48)
            }
            else {
                self.customMapBar.preferredContentSize = CGSize(width: -1, height: 65)
            }
        }) { (_ context) in
            //
        }
    }
    
	func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
		openPopup(animated: true, completion: nil)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { 
			self.popupContentVC.searchBar.becomeFirstResponder()
		}
		
		return false;
	}
	
	@IBAction private func backButtonTapped(_ sender: Any) {
	}
}
