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

//        let dateInputVM = DateInputViewModel(timeZoneGetter: { TimeZone.autoupdatingCurrent })
//        let dateInputVC = DateInputViewController(viewModel: dateInputVM)
//
//        add(dateInputVC)

//        dateInputVM.gregorianDateDriver
//            .drive(onNext: { date in
//                print("Got date! \(date)")
//            })
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
