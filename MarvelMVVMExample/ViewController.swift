//
//  ViewController.swift
//  MarvelMVVMExample
//
//  Created by Rodrigo Alejandro Velazquez Alcantara on 09/11/20.
//  Copyright © 2020 Rodrigo Alejandro Velazquez Alcantara. All rights reserved.
//

import UIKit
import MarvelMVVM

final class ViewController: UIViewController {

    @IBOutlet weak var openButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc func buttonTapped(_ sender: UIButton) {
        let vc = MarvelMVVMGatewayAdapter.instance.mainViewController()
        self.present(vc, animated: true, completion: nil)
    }
}

