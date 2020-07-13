//
//  Coordinator.swift
//  PitcherApp
//
//  Created by Bogdan Nikolaev on 12.07.2020.
//  Copyright © 2020 Bogdan Nikolaev. All rights reserved.
//

import UIKit

protocol CoordinatorProtocol: class {
    associatedtype ViewController: UIViewController
    var viewController: ViewController? { get set }
    var root: UINavigationController? { get }

    func createViewController() -> ViewController
    func configure(viewController: ViewController)
    func start(animated: Bool)
    func stop(animated: Bool)
}
