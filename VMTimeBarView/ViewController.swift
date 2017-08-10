//
//  ViewController.swift
//  VMTimeBarView
//
//  Created by Vaibhav Misra on 10/08/17.
//  Copyright © 2017 Vaibhav Misra. All rights reserved.
//

import UIKit

class ViewController: UIViewController, VMTimeBarViewDelegate {

    @IBOutlet weak var timerView: VMTimeBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.timerView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.timerView.startTimer(for: 21.0, withDelay: 2.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func timerDidFinish() {
         //Do Something when timer finishes
        print("Timer finished")
    }

}

