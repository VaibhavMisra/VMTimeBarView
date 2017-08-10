//
//  VMTimeBarView.swift
//  VMTimeBarView
//
//  Created by Vaibhav Misra on 10/08/17.
//  Copyright © 2017 Vaibhav Misra. All rights reserved.
//

import UIKit

protocol VMTimeBarViewDelegate: class {
    func timerDidFinish()
}

@IBDesignable
class VMTimeBarView: UIView {

    //MARK: - Public properties
    
    weak var delegate: VMTimeBarViewDelegate?
    
    @IBInspectable var boundaryColor: UIColor = .blue {
        didSet {
            self.backgroundColor = boundaryColor
        }
    }
    @IBInspectable var paddingColor: UIColor = .white {
        didSet {
            self.paddingView.backgroundColor = paddingColor
        }
    }
    @IBInspectable var timerColor: UIColor = .red {
        didSet {
            self.timerView.backgroundColor = timerColor
        }
    }
    @IBInspectable var timerLabelColor: UIColor = .red {
        didSet {
            self.timerLabel.textColor = timerLabelColor
        }
    }
    
    @IBInspectable var boundaryWidth: CGFloat = 1.0 {
        didSet {
            self.updateConstraints(forView: self.paddingView,
                                   withPadding: boundaryWidth)
        }
    }
    @IBInspectable var padding: CGFloat = 1.0 {
        didSet {
            self.updateConstraints(forView: self.timerView,
                                   withPadding: padding)
        }
    }
    
    //MARK: - Private properties
    private var paddingView: UIView = UIView()
    private var timerView: UIView = UIView()
    private var timerLabel: UILabel = UILabel()
    var countdown = 0
    var myTimer: Timer? = nil
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    //MARK: - Public methods
    
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
            self.delegate?.timerDidFinish()
        }

        self.countdown = Int(seconds)
        self.timerLabel.text = "\(countdown)"
        
        var delayInSeconds = 0.0
        if delay > 2.0 {
            delayInSeconds = delay - 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            
            self.myTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                                target: self,
                                                selector: #selector(VMTimeBarView.countDownTick),
                                                userInfo: nil, repeats: true)
        }
    }
    
    func countDownTick() {
        self.countdown -= 1
        if (countdown == 0) {
            self.myTimer!.invalidate()
            self.myTimer = nil
        }
        self.timerLabel.text = "\(countdown)"
    }
    
    //MARK: - Private Methods
    
    private func setupView() {
        self.backgroundColor = self.boundaryColor
        self.createView(view: self.paddingView,
                        parent: self,
                        padding: self.boundaryWidth,
                        color: self.paddingColor)
        self.createView(view: self.timerView,
                        parent: self.paddingView,
                        padding: self.padding,
                        color: self.timerColor)
        self.createLabel(label: self.timerLabel,
                         textColor: self.timerLabelColor,
                         parent: self.timerView,
                         padding: 0)
    }
    
    private func createView(view: UIView, parent: UIView,
                    padding: CGFloat, color: UIColor) {
        view.backgroundColor = color
        view.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(view)
        self.createPaddingConstraint(for: view,
                                     parent: parent,
                                     padding: padding)
    }
    
    private func createPaddingConstraint(for view: UIView,
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
    
    private func createLabel(label: UILabel, textColor: UIColor,
                             parent: UIView, padding: CGFloat) {
        label.text = "0"
        label.textAlignment = .center
        label.textColor = textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(label)
        self.pinToBottom(for: label,
                         parent: parent,
                         padding: padding)
    }
    
    private func pinToBottom(for view: UIView, parent: UIView, padding: CGFloat) {
        let heightConst = NSLayoutConstraint(item: view,
                                          attribute: .height,
                                          relatedBy: .equal,
                                          toItem: view,
                                          attribute: .height,
                                          multiplier: 1,
                                          constant: 30.0)
        
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
        NSLayoutConstraint.activate([heightConst, bottomConst, leadingConst, trailingConst])
    }
    
    private func updateConstraints(forView view: UIView,
                                   withPadding padding: CGFloat) {
        if let constraints = view.superview?.constraints {
            for const in constraints {
                if const.firstItem as! NSObject == view {
                    if (const.firstAttribute == .top ||
                        const.firstAttribute == .leading){
                        const.constant = padding
                    }
                    else if (const.firstAttribute == .bottom ||
                        const.firstAttribute == .trailing) {
                        const.constant = (-1 * padding)
                    }
                }
                
            }
        }
    }

}
