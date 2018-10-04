//
//  ContainerController+LNPopupCustomContainer.swift
//  LNPopupControllerExample
//
//  Created by Patrick BODET on 25/09/2018.
//  Copyright © 2018 Leo Natan. All rights reserved.
//

import UIKit

extension ContainerController {
    
    override public var bottomDockingViewForPopupBar: UIView? {
        return self.bottomBar
    }
    
    override public var defaultFrameForBottomDockingView: CGRect {
        var height: CGFloat = 50
        if #available(iOS 11.0, *) {
            height += self.view.superview?.safeAreaInsets.bottom ?? 0.0
        }
        return CGRect(x: 0, y: self.view.bounds.height - height, width: self.view.bounds.width, height: height)
    }
 
    override public var insetsForBottomDockingView: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return .zero
            //return self.view.superview?.safeAreaInsets ?? .zero
        } else {
            // Fallback on earlier versions
            return .zero
        }
    }
}
