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
        static let heroesTableViewCellIdentifier: String = "HeroesCell"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
}

extension HeroListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HeroesTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.heroesTableViewCellIdentifier, for: indexPath) as! HeroesTableViewCell
        //let model = presenter.models[indexPath.row]
        //cell.setUpHeroCell(image: model.heroImage ?? "", heroName: model.heroName ?? "", heroDescription: model.heroDescription ?? "")
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
        heroesTableView.register(UINib.init(nibName: Constants.heroesTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.heroesTableViewCellIdentifier)
        heroesTableView.register(UINib.init(nibName: Constants.heroesTableViewCellNibIdentifier, bundle: nil), forCellReuseIdentifier: Constants.heroesTableViewCellNibIdentifier)
    }
}

extension HeroListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let roundedOffset = (scrollView.contentOffset.y).rounded()
        heroesTableView.contentSize.height = contentSizeHeight
        headerView.updateSize(offset: roundedOffset + headerView.kMaxOffset)
    }
}

