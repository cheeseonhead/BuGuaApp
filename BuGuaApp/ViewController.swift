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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let guaXiang = LiuYaoGuaXiang(liuYao: [.youngYin, .oldYang, .youngYang, .youngYang, .oldYin, .youngYang])
        guaXiangView.guaXiangRelay.accept(guaXiang)
    }

    @IBAction func changed(_ sender: UISlider) {
        testingCGFloat = CGFloat(sender.value)
        print(testingCGFloat)
    }

    @IBAction func tapped(_ sender: Any) {
        let guaXiang = LiuYaoGuaXiang(liuYao: randomYao())

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
