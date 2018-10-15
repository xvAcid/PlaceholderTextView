//
//  ViewController.swift
//  PlaceholderTextView
//
//  Created by xvAcid on 31/08/2018.
//  Copyright © 2018 WSG4FUN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var placeholderTextView: PlaceholderTextView!
    @IBOutlet private weak var heigthConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        placeholderTextView.heightConstraint = heigthConstraint
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

