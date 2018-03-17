//
//  SearchBarInIpadViewController.swift
//  SearchBarInIpad
//
//  Created by Zoey Weng on 2018/3/15.
//  Copyright © 2018年 Zoey Weng. All rights reserved.
//

import UIKit

class SearchBarInIpadViewController: UIViewController {
    
    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.blue, for: .normal)
        cancelButton.sizeToFit()
        return cancelButton
    }()
    
    lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.blue, for: .normal)
        backButton.sizeToFit()
        return backButton
    }()
    
    lazy private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.tintColor = .orange
        searchBar.placeholder = "search"
        searchBar.alpha = 0.0
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tempTableView = UITableView(frame: .zero, style: .grouped)
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        tempTableView.backgroundColor = .white
        tempTableView.estimatedRowHeight = 44.0
        tempTableView.rowHeight = UITableViewAutomaticDimension
        tempTableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tempTableView.sectionFooterHeight = UITableViewAutomaticDimension
        tempTableView.estimatedSectionHeaderHeight = 35.0
        tempTableView.separatorColor = .orange
        tempTableView.tableFooterView = UIView()
        return tempTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.initView()
        self.initData()
    }

    @objc func cancelAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let navigationBarButtonFrame = self.navigationController?.navigationBar.frame {
            self.searchBar.frame = CGRect(x: self.backButton.frame.size.width + 30.0, y: (navigationBarButtonFrame.size.height - self.cancelButton.frame.size.height) / 2.0, width: navigationBarButtonFrame.size.width - self.cancelButton.frame.size.width - self.backButton.frame.size.width - 60.0, height: self.cancelButton.frame.size.height)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initView() {
        self.view.backgroundColor = .white
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let cancelButtonItem = UIBarButtonItem(customView: self.cancelButton)
            self.cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = cancelButtonItem
            
            let backlButtonItem = UIBarButtonItem(customView: self.backButton)
            self.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
            self.navigationItem.leftBarButtonItem = backlButtonItem
            
            if let navigationBarButtonFrame = self.navigationController?.navigationBar.frame {
                self.searchBar.frame = CGRect(x: self.backButton.frame.size.width + 30.0, y: (navigationBarButtonFrame.size.height - self.cancelButton.frame.size.height) / 2.0, width: navigationBarButtonFrame.size.width - self.cancelButton.frame.size.width - self.backButton.frame.size.width - 60.0, height: self.cancelButton.frame.size.height)
                self.navigationItem.titleView = self.searchBar
            }
        }
        
        self.view.addSubview(self.tableView)
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        } else {
            self.tableView.topAnchor.constraint(equalTo: self.topLayoutGuide.topAnchor).isActive = true
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.bottomAnchor).isActive = true
        }
    }
    
    private func initData() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

// MARK: tableView DataSource
extension SearchBarInIpadViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self))
        cell?.textLabel?.textColor = .black
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }
}

// MARK: tableView Delegate
extension SearchBarInIpadViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let vc = ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
