//
//  FadeViewController.swift
//  StatusBar-sample
//
//  Created by 大澤卓也 on 2018/02/09.
//  Copyright © 2018年 Takuya Ohsawa. All rights reserved.
//

import Foundation
import UIKit

final class FadeViewController: UIViewController {
    private let lock = DispatchSemaphore(value: 1)
    private var isHiddenStatusBar: Bool = false {
        didSet {
            
            guard let navigationController = navigationController else {
                return
            }
            
            switch lock.wait(wallTimeout: .now()) {
            case .success:
                if isHiddenStatusBar {
                    UIView.transition(with: navigationController.navigationBar, duration: TimeInterval(UINavigationControllerHideShowBarDuration), options: [.transitionCrossDissolve], animations: {
                        navigationController.navigationBar.isHidden = true
                    }, completion: { (_) in
                        navigationController.navigationBar.isHidden = false
                        navigationController.isNavigationBarHidden = true
                        self.lock.signal()
                        UIView.animate(withDuration: TimeInterval(UINavigationControllerHideShowBarDuration)) { [weak self] in
                            self?.setNeedsStatusBarAppearanceUpdate()
                        }
                    })
                } else {
                    navigationController.isNavigationBarHidden = false
                    navigationController.navigationBar.isHidden = true
                    UIView.transition(with: navigationController.navigationBar, duration: TimeInterval(UINavigationControllerHideShowBarDuration), options: [.transitionCrossDissolve], animations: {
                        navigationController.navigationBar.isHidden = false
                    }, completion: { (_) in
                        self.lock.signal()
                        UIView.animate(withDuration: TimeInterval(UINavigationControllerHideShowBarDuration)) { [weak self] in
                            self?.setNeedsStatusBarAppearanceUpdate()
                        }
                    })
                }
                
            default: break
            }
        }
    }
    private var lastContentOffset: CGPoint = .zero
    private var scrollDirection: ScrollDirection = .none {
        didSet {
            switch scrollDirection {
            case .up:
                isHiddenStatusBar = false
            case .down:
                isHiddenStatusBar = true
            default:
                break
            }
        }
    }
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
        title = "Fade"
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return isHiddenStatusBar
        }
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        get {
            return .fade
        }
    }
}

extension FadeViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !scrollView.isBouncing, scrollView.isDragging else {
            return
        }
        
        if self.lastContentOffset.y > scrollView.contentOffset.y {
            scrollDirection = .up
        } else if self.lastContentOffset.y < scrollView.contentOffset.y {
            scrollDirection = .down
        }
        
        self.lastContentOffset = scrollView.contentOffset
    }
}

extension FadeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = indexPath.row.description
        return cell
    }
}

