//
//  CryptoCell.swift
//  CryptoTracker
//
//  Created by Gabriela Sillis on 04/11/21.
//

import UIKit
import Kingfisher
import SwiftUI

final class CryptoCell: UITableViewCell {

    static var identifier: String {
        return String(describing: CryptoCell.self)
    }

    //    private var task: URLSessionDataTask?

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .systemGray

        return label
    }()

    private var symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray2

        return label
    }()

    private var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .systemGreen
        label.textAlignment = .right

        return label
    }()

    private var imageLogo: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit

        return image
    }()

    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, symbolLabel])
        stackView.axis = .vertical
        stackView.spacing = 8

        let containerStack = UIStackView(arrangedSubviews: [stackView, priceLabel])
        containerStack.spacing = 4

        return containerStack
    }()

    private lazy var containerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageLogo,labelsStackView])
        stack.spacing = 20

        return stack

    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        clear()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clear()
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: CryptoCellModel) {
        nameLabel.text = model.name
        symbolLabel.text = model.symbol
        priceLabel.text = model.price

        imageLogo.kf.indicatorType = .activity
        let retry = DelayRetryStrategy(maxRetryCount: 3, retryInterval: .seconds(3))

        imageLogo.kf.setImage(with: URL(string: model.imageString),
                              options: [.retryStrategy(retry),
                                        .transition(ImageTransition.fade(1))]) {
            result in

            switch result {
                case.failure:
                    self.imageLogo.image = UIImage(named: "placeholder-image")
                default:
                    break
            }
        }
        //        task = imageLogo.downloadImage(from: model.imageString)
    }

    private func clear() {

        // mantem a cell no estado inicial evitando cache
        nameLabel.text = nil
        symbolLabel.text = nil
        priceLabel.text = nil
        imageLogo.kf.cancelDownloadTask()

        //        task?.cancel()
        //        task = nil
    }
}

extension CryptoCell: ViewCode {
    func buildViewHierarchy() {
        addSubview(containerStackView)
    }

    func addConstraints() {
        imageLogo.constrainWidth(60)
        containerStackView.fillSuperview(padding: UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18))
    }

    func additionalConfiguration() {}
}
