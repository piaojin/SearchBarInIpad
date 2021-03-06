//
//  TestViewController.swift
//  SearchBarInIpad
//
//  Created by Zoey Weng on 2018/3/15.
//  Copyright © 2018年 Zoey Weng. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TestSearchBar"
        self.view.backgroundColor = .white
        let button = UIButton()
        button.setTitle("pushToSearchBar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func buttonClick() {
        let vc = SearchBarInIpadViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
