//
//  ViewController.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-08-27.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import UIKit

var testingCGFloat: CGFloat = 0

class ViewController: UIViewController {
    let guaXiangBuilder = LiuYaoGuaXiangBuilder()

    override func viewDidLoad() {
        super.viewDidLoad()

        let pageController = BGPageController(viewControllers: [])
        add(pageController)

        pageController.contentRatio = 672 / 488
        pageController.maxSize = CGSize(width: 488, height: 672)
        pageController.minimumMultiPageWidth = 488
        pageController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let guaXiang = guaXiangBuilder.build()
    }

    @IBAction func changed(_ sender: UISlider) {
        testingCGFloat = CGFloat(sender.value)
        print(testingCGFloat)
    }

    @IBAction func tapped(_: Any) {
        guaXiangBuilder.setLiuYao(randomYao())
        let guaXiang = guaXiangBuilder.build()

        print("\(guaXiang.originalGua.innerGua.character) \(guaXiang.originalGua.outerGua.character)")

//        present(GuaXiangViewController(), animated: true, completion: nil)
    }

    func randomYao() -> [YaoType] {
        return (1 ... 6).reduce(into: []) { result, _ in
            result.append(YaoType.allCases.randomElement()!)
        }
    }
}
