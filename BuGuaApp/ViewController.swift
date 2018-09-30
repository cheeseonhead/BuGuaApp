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

        let factory = AppFactory()

        let vm = factory.makeTimeInputViewModel()
        let vc = factory.makeTimeInputViewController(viewModel: vm)

        add(vc)

        vc.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

//        vm.gregorianTimeRelay.drive(onNext: { (time) in
//            print(time)
//        })
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
