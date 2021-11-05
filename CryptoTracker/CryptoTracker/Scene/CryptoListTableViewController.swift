//
//  CryptoListTableViewController.swift
//  CryptoTracker
//
//  Created by Gabriela Sillis on 04/11/21.
//

import UIKit

final class CryptoListTableViewController: UIViewController {

    private let viewModel = CryptoListViewModel()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.register(CryptoCell.self, forCellReuseIdentifier: CryptoCell.identifier)


        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func getCryptoCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoCell.identifier, for: indexPath) as? CryptoCell else {
            return UITableViewCell()
        }

        let model = viewModel.modelForRow(at: indexPath.row)
        cell.configure(with: model)
        return cell
    }
}

extension CryptoListTableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCryptoCell(indexPath: indexPath)
    }
}

extension CryptoListTableViewController: ViewCode {

    func buildViewHierarchy() {
        view.addSubview(tableView)
    }

    func addConstraints() {
        tableView.fillSuperview()
    }

    func additionalConfiguration() {
        title = "Crypto Tracker"
    }
}
