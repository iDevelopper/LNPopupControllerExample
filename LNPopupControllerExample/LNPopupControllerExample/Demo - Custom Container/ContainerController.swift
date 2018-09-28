//
//  ContainerController.swift
//  LNPopupControllerExample
//
//  Created by Patrick BODET on 25/09/2018.
//  Copyright © 2018 Leo Natan. All rights reserved.
//

import UIKit

public extension UIViewController{
    
    public var containerController: ContainerController? {
        var current: UIViewController? = parent
        
        repeat {
            if current is ContainerController { return current as? ContainerController }
            current = current?.parent
        } while current != nil
        
        return nil
    }
}

public class ContainerController: UIViewController {
    
    let useConstraintsForBottomBar: Bool = true
    let useSafeAreaLayoutGuideForChild: Bool = true

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    var viewControllers: [UIViewController?]! {
        didSet {
            for controller in viewControllers {
                if controller != nil {
                    addChildViewController(controller!)
                }
            }
        }
    }

    var selectedIndex: Int = 0
    var currentChildVC: UIViewController!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers = [UIViewController]()
        
        buttonsStackView.alignment = .fill
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 0
        
        for button in (self.buttonsStackView?.arrangedSubviews)! {
            (button as! UIButton).addTarget(self, action: #selector(self.tabButtonAction(button:)), for: .touchUpInside)
        }
        
        let childVC1 = self.storyboard?.instantiateViewController(withIdentifier: "ChildViewController") as? ChildViewController
        childVC1?.view.backgroundColor = LNRandomLightColor()
        
        let childVC2 = self.storyboard?.instantiateViewController(withIdentifier: "ChildViewController") as? ChildViewController
        childVC2?.view.backgroundColor = LNRandomLightColor()
        childVC2?.title = "ChildVC2"
        let nc = UINavigationController(rootViewController: childVC2!)
        nc.view.backgroundColor = childVC2?.view.backgroundColor

        let childVC3 = self.storyboard?.instantiateViewController(withIdentifier: "ChildViewController") as? ChildViewController
        childVC3?.view.backgroundColor = LNRandomLightColor()

        self.viewControllers = [childVC1, nc, childVC3]
        
        self.selectedIndex = 0
        
        self.presentChild()
        
        print("childs: \(childViewControllers)")
    }
    
    func tabButtonAction(button: UIButton) {
        print("button: \(String(describing: button.currentTitle))")
        if let index = self.buttonsStackView.arrangedSubviews.index(of: button) {
            if index != self.selectedIndex {
                self.selectedIndex = index
                self.presentChild()
            }
        }
    }
    
    func presentChild() {
        if let childVC = self.viewControllers[selectedIndex] {
            self.containerView.addSubview(childVC.view)
            childVC.didMove(toParentViewController: self)
            self.currentChildVC?.willMove(toParentViewController: nil)
            self.currentChildVC?.view.removeFromSuperview()
            self.currentChildVC = childVC
            
            self.view.backgroundColor = currentChildVC.view.backgroundColor
            self.setupConstraintsForChildController()
        }
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if useConstraintsForBottomBar == true {
            self.setupConstraintsForBottomBar()
        }
        else {
            self.setupFrameForBottomBar()
        }
        self.setupConstraintsForButtonsStackView()
        self.setupConstraintsForContainerView()
    }
    
    func setupConstraintsForContainerView() {
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo:(self.view.topAnchor)),
            self.containerView.leftAnchor.constraint(equalTo: (self.view.leftAnchor)),
            self.containerView.rightAnchor.constraint(equalTo: (self.view.rightAnchor)),
            self.containerView.bottomAnchor.constraint(equalTo: (bottomBar.topAnchor))
            ])
    }
    
    func setupConstraintsForBottomBar() {
        var height: CGFloat = 50
        if #available(iOS 11.0, *) {
            height += self.view.superview?.safeAreaInsets.bottom ?? 0.0
        }
        NSLayoutConstraint.deactivate(self.bottomBar.constraints)
        self.bottomBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.bottomBar.leadingAnchor.constraint(equalTo: (self.view.leadingAnchor)),
            self.bottomBar.trailingAnchor.constraint(equalTo: (self.view.trailingAnchor)),
            self.bottomBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.bottomBar.heightAnchor.constraint(equalToConstant: height)
            ])
    }
    
    func setupConstraintsForButtonsStackView() {
        self.buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buttonsStackView.topAnchor.constraint(equalTo: self.bottomBar.topAnchor),
            self.buttonsStackView.leadingAnchor.constraint(equalTo: self.bottomBar.leadingAnchor, constant: 0),
            self.buttonsStackView.trailingAnchor.constraint(equalTo: self.bottomBar.trailingAnchor, constant: 0),
            self.buttonsStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    func setupConstraintsForChildController() {
        currentChildVC.view.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            self.currentChildVC.view.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
            self.currentChildVC.view.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
            self.currentChildVC.view.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
            if useSafeAreaLayoutGuideForChild == true {
                let guide = self.view.safeAreaLayoutGuide
                self.currentChildVC.view.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -50).isActive = true
            }
            else {
                self.currentChildVC.view.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor).isActive = true
            }
        } else {
            // Fallback on earlier versions
            self.currentChildVC.view.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
            self.currentChildVC.view.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
            self.currentChildVC.view.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
            self.currentChildVC.view.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor).isActive = true
        }
    }
    
    func setupFrameForBottomBar() {
        var height: CGFloat = 50
        if #available(iOS 11.0, *) {
            height += self.view.superview?.safeAreaInsets.bottom ?? 0.0
        }
        self.bottomBar.frame = CGRect(x: 0, y: self.view.bounds.height - height, width: self.view.bounds.width, height: height)
    }
}
