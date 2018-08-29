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

    @IBOutlet weak var guaXiangView: GuaXiangView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let guaXiang = LiuYaoGuaXiang(liuYao: [.youngYin, .youngYang, .youngYang, .youngYang, .youngYang, .youngYang])
        guaXiangView.guaXiangRelay.accept(guaXiang)
    }

    @IBAction func tapped(_ sender: Any) {
        let guaXiang = LiuYaoGuaXiang(liuYao: randomYao())

        print("\(guaXiang.originalGua.innerGua.character) \(guaXiang.originalGua.outerGua.character)")
        guaXiangView.guaXiangRelay.accept(guaXiang)
    }

    func randomYao() -> [YaoType] {
        return (1...6).reduce(into: []) { result, _ in
            result.append(YaoType.allCases.randomElement()!)
        }
    }
}
