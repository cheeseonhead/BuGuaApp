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

        func makeVC() -> UIViewController {
            let vc = UIViewController()
            vc.view.backgroundColor = .red

            return vc
        }

        let pageController = BGPageController(viewControllers: [makeVC(), makeVC()])
        add(pageController)

        pageController.inset = 16
        pageController.minimumPageSpacing = 8
        pageController.maxSize = CGSize(width: 634.4, height: 873.6)
        pageController.minimumMultiPageWidth = 430
        pageController.view.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.size.equalTo(CGSize(width: 500, height: 500))
            make.edges.equalToSuperview()
        }
        pageController.view.clipsToBounds = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
