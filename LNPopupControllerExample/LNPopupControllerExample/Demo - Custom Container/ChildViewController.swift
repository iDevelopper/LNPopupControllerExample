//
//  ChildViewController.swift
//  LNPopupControllerExample
//
//  Created by Patrick BODET on 25/09/2018.
//  Copyright © 2018 Leo Natan. All rights reserved.
//

import UIKit

class ChildViewController: UIViewController {
    
    //var containerController: ContainerController!
    
    @IBAction private func backButtonTapped(_ sender: Any) {
    }
    
    @IBAction func present(_ sender: UIButton) {
        //self.presentPopup()
        self.presentCustomPopup()
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismissPopup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func presentCustomPopup() {
        if let containerVC = self.containerController {
            let customYTBar = storyboard!.instantiateViewController(withIdentifier: "CustomYTBarViewController") as! CustomYTBarViewController
            customYTBar.view.backgroundColor = .clear
            containerVC.popupBar.isTranslucent = false
            containerVC.popupBar.backgroundColor = .clear
            containerVC.popupBar.inheritsVisualStyleFromDockingView = false
            containerVC.popupBar.customBarViewController = customYTBar
            containerVC.popupContentView.popupCloseButtonStyle = .round
            containerVC.popupInteractionStyle = .snap
            let popupContentController = UIStoryboard(name: "Music", bundle: nil).instantiateViewController(withIdentifier: "DemoMusicPlayerController") as! DemoMusicPlayerController
            popupContentController.songTitle = "Youtube style example"
            popupContentController.albumTitle = "Example"
            popupContentController.albumArt = UIImage(named: "genre\(1)")!
            DispatchQueue.main.async {
                containerVC.presentPopupBar(withContentViewController: popupContentController, animated: true) {
                    print("PopupBar presented")
                }
            }
        }
    }
    
    func presentPopup() {
        if let containerVC = self.containerController {
            containerVC.popupBar.inheritsVisualStyleFromDockingView = false
            let popupContentController = UIStoryboard(name: "Music", bundle: nil).instantiateViewController(withIdentifier: "DemoMusicPlayerController") as! DemoMusicPlayerController
            popupContentController.songTitle = "Song"
            popupContentController.albumTitle = "Title"
            popupContentController.albumArt = UIImage(named: "genre\(1)")!
            
            containerVC.presentPopupBar(withContentViewController: popupContentController, animated: true) {
                print("PopupBar presented")
            }
        }
    }
    
    func dismissPopup() {
        if let containerVC = self.containerController {
            containerVC.dismissPopupBar(animated: true) {
                print("PopupBar dismissed")
            }
        }
    }
    
    @IBAction func additionalSafeArea(_ sender: UIButton) {
        if let containerVC = self.containerController {
            if #available(iOS 11.0, *) {
                print("additional isnsets bottom: \(containerVC.additionalSafeAreaInsets.bottom)")
                containerVC.additionalSafeAreaInsets.bottom += 64
                containerVC.view.layoutIfNeeded()
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    @IBAction func resetAdditionalSafeArea(_ sender: UIButton) {
        if let containerVC = self.containerController {
            if #available(iOS 11.0, *) {
                print("additional insets bottom: \(containerVC.additionalSafeAreaInsets.bottom)")
                containerVC.additionalSafeAreaInsets.bottom = 0
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
