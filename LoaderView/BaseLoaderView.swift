//
//  BaseLoaderView.swift
//  ForteApp
//
//  Created by Dauren on 25/04/2022.
//

import UIKit

struct LoaderConfig {
    var lineWidth: CGFloat = 4
    var duration: CFTimeInterval = 1
    var padding: CGFloat = 12
    var gradientColors: [CGColor] = [
        UIColor.white.withAlphaComponent(0.25).cgColor,
        UIColor.systemBlue.cgColor
    ]
}

final class BaseLoaderView: UIView {

    // MARK: - Types

    private enum Constants {
        static let animationKeyPath = "transform.rotation.z"
        static let animationKey = "spinnerAnimation"
        static let startAngle: CGFloat = .pi / 3
        static let endAngle: CGFloat = .pi * 2
    }

    // MARK: - Properties

    private let config: LoaderConfig

    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.type = .conic
        layer.startPoint = CGPoint(x: 0.5, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.75)
        layer.colors = config.gradientColors
        return layer
    }()

    private lazy var maskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth = config.lineWidth
        layer.lineCap = .round
        return layer
    }()

    // MARK: - Init

    init(config: LoaderConfig = LoaderConfig()) {
        self.config = config
        super.init(frame: .zero)
        alpha = 0
        backgroundColor = .white
        layer.addSublayer(gradientLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        applyShadow()
        layoutGradient()
    }

    // MARK: - Public Methods

    func startAnimating() {
        let animation = CABasicAnimation(keyPath: Constants.animationKeyPath)
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.duration = config.duration
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: Constants.animationKey)

        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }

    func stopAnimating() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.gradientLayer.removeAnimation(forKey: Constants.animationKey)
        }
    }

    // MARK: - Private Methods

    private func applyShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowRadius = 12
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    private func layoutGradient() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = bounds.midY - config.lineWidth - config.padding
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: Constants.startAngle,
            endAngle: Constants.endAngle,
            clockwise: true
        )
        maskLayer.path = path.cgPath
        gradientLayer.frame = bounds
        gradientLayer.mask = maskLayer
    }
}
