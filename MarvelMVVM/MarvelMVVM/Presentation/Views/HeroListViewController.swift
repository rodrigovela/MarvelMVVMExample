//
//  HeroListViewController.swift
//  MarvelMVVM
//
//  Created by Rodrigo Alejandro Velazquez Alcantara on 09/11/20.
//  Copyright © 2020 Rodrigo Alejandro Velazquez Alcantara. All rights reserved.
//

import UIKit

class HeroListViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var heroesTableView: UITableView!
    @IBOutlet fileprivate weak var headerView: HeroImageModule!

    // MARK: - Variables and constants
    
    struct Constants {
        static let heroesTableViewCellIdentifier: String = "HeroesTableViewCell"
        static let estimatedTableRowHeight: CGFloat = 300
        static let heroesTableViewCellNibIdentifier: String = "HeroImageModule"
        static let heroesTableViewCell: String = "HeroesTableViewCell"
    }
    
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    var contentSizeHeight: CGFloat {
        return (heroesTableView.contentSize.height > screenHeight) ? heroesTableView.contentSize.height : screenHeight
    }
    
    private let viewModel: HeroListViewModelProtocol
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.sceneDidLoad()
        configureTableView()
        self.viewModel.heroes.bind { [weak self] _ in
            self?.heroesTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    init?(viewModel: HeroListViewModelProtocol, coder: NSCoder){
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(viewModel:coder:)")
    }
}

extension HeroListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.heroes.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HeroesTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.heroesTableViewCellIdentifier, for: indexPath) as! HeroesTableViewCell
        cell.setUpHeroCell(viewModel: viewModel.heroes.value[indexPath.row])
        return cell
    }
}

extension HeroListViewController {

    func configureTableView() {
        registerCells()
        heroesTableView.delegate = self
        heroesTableView.dataSource = self
        heroesTableView.rowHeight = UITableView.automaticDimension
        heroesTableView.estimatedRowHeight = Constants.estimatedTableRowHeight
        heroesTableView.contentInset = UIEdgeInsets(top: headerView.frame.height, left: 0, bottom: 0, right: 0)
        heroesTableView.tableFooterView = UIView()
    }
    
    func registerCells() {
        heroesTableView.register(UINib.init(nibName: Constants.heroesTableViewCell, bundle: Bundle(for: ViewProviderAdapter.self)), forCellReuseIdentifier: Constants.heroesTableViewCellIdentifier)
        heroesTableView.register(UINib.init(nibName: Constants.heroesTableViewCellNibIdentifier, bundle: Bundle(for: ViewProviderAdapter.self)), forCellReuseIdentifier: Constants.heroesTableViewCellNibIdentifier)
    }
}

extension HeroListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let roundedOffset = (scrollView.contentOffset.y).rounded()
        heroesTableView.contentSize.height = contentSizeHeight
        headerView.updateSize(offset: roundedOffset + headerView.kMaxOffset)
    }
}

