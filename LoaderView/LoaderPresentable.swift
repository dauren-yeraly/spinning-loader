//
//  LoaderPresentable.swift
//  ForteApp
//
//  Created by Dauren on 25/04/2022.
//

import UIKit

protocol LoaderPresentable: AnyObject {
    func showLoader()
    func hideLoader()
}

extension LoaderPresentable where Self: UIViewController {

    // MARK: - Properties

    private var loaderView: DimmingLoaderView? {
        view.subviews.compactMap { $0 as? DimmingLoaderView }.first
    }

    // MARK: - Public Methods

    func showLoader() {
        guard loaderView == nil else { return }

        let loader = DimmingLoaderView()
        loader.frame = view.bounds
        loader.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(loader)
        view.bringSubviewToFront(loader)
        setCornerRadius(for: loader)
        loader.startAnimating()
    }

    func hideLoader() {
        loaderView?.stopAnimating()
    }

    // MARK: - Private Methods

    private func setCornerRadius(for loader: UIView) {
        loader.clipsToBounds = true
        loader.layer.cornerRadius = view.layer.cornerRadius
        loader.layer.maskedCorners = view.layer.maskedCorners
    }
}
