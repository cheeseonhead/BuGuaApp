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
    @IBOutlet weak var yaoView: YaoView!
    @IBOutlet weak var yaoView2: YaoView!
    @IBOutlet weak var yaoView3: YaoView!
    @IBOutlet weak var yaoView4: YaoView!

    override func viewDidLoad() {
        super.viewDidLoad()

        yaoView.yaoRelay.accept(.youngYang)
        yaoView2.yaoRelay.accept(.youngYin)
        yaoView3.yaoRelay.accept(.oldYin)
        yaoView4.yaoRelay.accept(.oldYang)

        let ttt = CGRect(x: 0, y: 0, width: 50, height: 100).scaledAtCenter(scaleX: 0.5, scaleY: 0.5)
        print(ttt)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let guaXiang = LiuYaoGuaXiang(liuYao: [.youngYin, .youngYang, .youngYang, .youngYang, .youngYang, .youngYang])
        guaXiangView.guaXiangRelay.accept(guaXiang)
    }

    @IBAction func changed(_ sender: UISlider) {
        testingCGFloat = CGFloat(sender.value)
        print(testingCGFloat)
        yaoView2.setNeedsDisplay()
    }

    @IBAction func tapped(_ sender: Any) {
        let guaXiang = LiuYaoGuaXiang(liuYao: randomYao())

        print("\(guaXiang.originalGua.innerGua.character) \(guaXiang.originalGua.outerGua.character)")
        guaXiangView.guaXiangRelay.accept(guaXiang)

        yaoView.yaoRelay.accept(YaoType.allCases.randomElement()!)
        yaoView2.yaoRelay.accept(YaoType.allCases.randomElement()!)
    }

    func randomYao() -> [YaoType] {
        return (1...6).reduce(into: []) { result, _ in
            result.append(YaoType.allCases.randomElement()!)
        }
    }
}
