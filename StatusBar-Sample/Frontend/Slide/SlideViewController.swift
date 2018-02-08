//
//  SlideViewController.swift
//  StatusBar-sample
//
//  Created by 大澤卓也 on 2018/02/09.
//  Copyright © 2018年 Takuya Ohsawa. All rights reserved.
//

import Foundation
import UIKit

final class SlideViewController: UIViewController {
    private var isHiddenStatusBar: Bool = false {
        didSet {
            guard isHiddenStatusBar != oldValue else {
                return
            }
            guard let navigationController = navigationController else {
                return
            }
            
            navigationController.setNavigationBarHidden(isHiddenStatusBar, animated: true)
        }
    }
    private var lastContentOffset: CGFloat = 0
    private static let cellReuseIdentifier = "cell"
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: type(of: self).cellReuseIdentifier)
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Slide"
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return navigationController?.isNavigationBarHidden ?? false
        }
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        get {
            return .slide
        }
    }
}

extension SlideViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.lastContentOffset > scrollView.contentOffset.y,
            self.lastContentOffset < (scrollView.contentSize.height - scrollView.frame.height) {
            // move up
            isHiddenStatusBar = false
        } else if self.lastContentOffset < scrollView.contentOffset.y, scrollView.contentOffset.y > 0 {
            // move down
            isHiddenStatusBar = true
        }
        
        self.lastContentOffset = scrollView.contentOffset.y
    }
}

extension SlideViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 500
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = indexPath.row.description
        return cell
    }
}