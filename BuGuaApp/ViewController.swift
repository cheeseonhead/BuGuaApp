//
//  ViewController.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-08-27.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import UIKit
import BuGuaKit

var testingCGFloat: CGFloat = 0

class ViewController: UIViewController {

    @IBOutlet weak var guaXiangView: GuaXiangView!

    let guaXiangBuilder = LiuYaoGuaXiangBuilder()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let guaXiang = guaXiangBuilder.build()
        guaXiangView.guaXiangRelay.accept(guaXiang)
    }

    @IBAction func changed(_ sender: UISlider) {
        testingCGFloat = CGFloat(sender.value)
        print(testingCGFloat)
    }

    @IBAction func tapped(_ sender: Any) {
        guaXiangBuilder.setLiuYao(randomYao())
        let guaXiang = guaXiangBuilder.build()

        print("\(guaXiang.originalGua.innerGua.character) \(guaXiang.originalGua.outerGua.character)")
        guaXiangView.guaXiangRelay.accept(guaXiang)

//        present(GuaXiangViewController(), animated: true, completion: nil)

    }

    func randomYao() -> [YaoType] {
        return (1...6).reduce(into: []) { result, _ in
            result.append(YaoType.allCases.randomElement()!)
        }
    }
}
