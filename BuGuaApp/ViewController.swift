//
//  ViewController.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-08-27.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import UIKit
import BuGuaKit

class ViewController: UIViewController {

    @IBOutlet weak var baGuaView: FuXiBaGuaView!

    override func viewDidLoad() {
        super.viewDidLoad()


    }


    @IBAction func tapped(_ sender: Any) {
        let randomBaGua = FuXiBaGua.allCases.randomElement()!

        baGuaView.baGua = randomBaGua
    }
}

