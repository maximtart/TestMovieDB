//
//  UITableView+Extensions.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 18.09.2022.
//

import UIKit

final class GradientView: UIView {

    struct GradientSettings {
        let startPoint: CGPoint
        let endPoint: CGPoint
        let locations: [Float]?

        init(startPoint: CGPoint, endPoint: CGPoint, locations: [Float]?) {
            self.startPoint = startPoint
            self.endPoint = endPoint
            self.locations = locations
        }
    }

    enum GradientDirection {
        case vertical
        case horizontal
        case custom(GradientSettings)

        var startPoint: CGPoint {
            switch self {
            case .custom(let settings):
                return settings.startPoint
            default:
                return CGPoint(x: 0, y: 0)
            }
        }

        var endPoint: CGPoint {
            switch self {
            case .horizontal:
                return CGPoint(x: 1, y: 0)
            case .vertical:
                return CGPoint(x: 0, y: 1)
            case .custom(let settings):
                return settings.endPoint
            }
        }

        var locations: [Float]? {
            switch self {
            case .custom(let settings):
                return settings.locations
            default:
                return nil
            }
        }
    }

    // MARK: - Properties
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    var direction: GradientDirection = .horizontal {
        didSet { updateColor() }
    }

    var startColor: UIColor = .yellow {
        didSet { updateColor() }
    }

    var endColor: UIColor = .orange {
        didSet { updateColor() }
    }

    public var colors: [UIColor]? {
        didSet { updateColor() }
    }

    // MARK: - Initializators
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateColor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateColor()
    }
}

// MARK: - Private methods
private extension GradientView {

    func updateColor() {
        guard let layer = layer as? CAGradientLayer else { return }
        layer.startPoint = direction.startPoint
        layer.endPoint = direction.endPoint
        layer.locations = direction.locations?.map { NSNumber(value: $0) }
        if let colors = colors {
            layer.colors = colors.map { $0.cgColor }
        } else {
            layer.colors = [startColor.cgColor, endColor.cgColor]
        }
    }
}
