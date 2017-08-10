//
//  VMTimeBarView.swift
//  VMTimeBarView
//
//  Created by Vaibhav Misra on 10/08/17.
//  Copyright © 2017 Vaibhav Misra. All rights reserved.
//

import UIKit

class VMTimeBarView: UIView {

    //Public properties
    var boundaryColor = UIColor.blue
    var paddingColor = UIColor.white
    var timerColor = UIColor.red
    var padding: CGFloat = 10.0
    
    private var paddingView: UIView = UIView()
    private var timerView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    func setupView() {
        self.backgroundColor = self.boundaryColor
        self.createView(view: self.paddingView,
                        parent: self,
                        padding: 4.0,
                        color: self.paddingColor)
        self.createView(view: self.timerView,
                        parent: self.paddingView,
                        padding: self.padding,
                        color: self.timerColor)
    }
    
    func createView(view: UIView, parent: UIView,
                    padding: CGFloat, color: UIColor) {
        view.backgroundColor = color
        view.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(view)
        self.createPaddingConstraint(for: view,
                                     parent: parent,
                                     padding: padding)
    }
    
    func createPaddingConstraint(for view: UIView,
                                 parent: UIView, padding: CGFloat) {
        let topConst = NSLayoutConstraint(item: view,
                                          attribute: .top,
                                          relatedBy: .equal,
                                          toItem: parent,
                                          attribute: .top,
                                          multiplier: 1.0,
                                          constant: padding)
        
        let bottomConst = NSLayoutConstraint(item: view,
                                             attribute: .bottom,
                                             relatedBy: .equal,
                                             toItem: parent,
                                             attribute: .bottom,
                                             multiplier: 1.0,
                                             constant: (-1 * padding))
        
        let leadingConst = NSLayoutConstraint(item: view,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: parent,
                                              attribute: .leading,
                                              multiplier: 1.0,
                                              constant: padding)
        
        let trailingConst = NSLayoutConstraint(item: view,
                                               attribute: .trailing,
                                               relatedBy: .equal,
                                               toItem: parent,
                                               attribute: .trailing,
                                               multiplier: 1.0,
                                               constant: (-1 * padding))
        NSLayoutConstraint.activate([topConst, bottomConst, leadingConst, trailingConst])
    }
    
    func startTimer(for seconds: TimeInterval, withDelay delay: TimeInterval) {
        let constraints = self.paddingView.constraints
        for const in constraints {
            if const.firstItem as! NSObject == self.timerView,
                const.firstAttribute == .top {
                const.constant = self.paddingView.bounds.maxY - self.padding
            }
        }
        
        UIView.animate(withDuration: seconds,
                       delay: delay,
                       options: .layoutSubviews,
                       animations: {
                        self.layoutIfNeeded()
        }) { (isFinished) in
            //
        }
    }

}
