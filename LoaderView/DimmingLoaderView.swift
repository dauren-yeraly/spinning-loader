//
//  DimmingLoaderView.swift
//  ForteApp
//
//  Created by Dauren on 06/05/2022.
//

import UIKit

final class DimmingLoaderView: UIView {
    
    // MARK: - Types

    private enum Constants {
        static let size: CGFloat = 72
    }

    // MARK: - UI Components

    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let loaderView: BaseLoaderView = {
        let view = BaseLoaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func startAnimating() {
        loaderView.startAnimating()
        UIView.animate(withDuration: 0.3) {
            self.dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        }
    }

    func stopAnimating(completion: (() -> Void)? = nil) {
        loaderView.stopAnimating()
        UIView.animate(withDuration: 0.3, animations: {
            self.dimmingView.backgroundColor = .clear
        }, completion: { _ in
            self.removeFromSuperview()
            completion?()
        })
    }

    // MARK: - Private Methods

    private func setupView() {
        addSubview(dimmingView)
        addSubview(loaderView)

        NSLayoutConstraint.activate([
            dimmingView.topAnchor.constraint(equalTo: topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: trailingAnchor),

            loaderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loaderView.widthAnchor.constraint(equalToConstant: Constants.size),
            loaderView.heightAnchor.constraint(equalToConstant: Constants.size)
        ])
    }
}
