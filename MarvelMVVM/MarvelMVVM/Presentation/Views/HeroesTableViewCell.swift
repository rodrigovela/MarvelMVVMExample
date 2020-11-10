//
//  HeroesTableViewCell.swift
//  MarvelMVVMExample
//
//  Created by Ivan F Garcia S on 09/11/20.
//  Copyright © 2020 Ivan F Garcia S. All rights reserved.
//

import UIKit

struct HeroesTableViewCellViewModel {
    var image: Observable<UIImage?>
    var heroName: String
    var heroDescription: String
    var onViewWillDisplay: (() -> Void)?
}

final class HeroesTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var heroeImage: ImageViewWithGradient!
    @IBOutlet weak var heroeNameLabel: UILabel!
    @IBOutlet weak var heroeDescriptionLabel: UILabel!
    
    static let headerModuleHeightFromSafeArea: CGFloat = 220

    // MARK: - Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        self.selectionStyle = .none
        
    }
    
    private var heroThumbnail: Observable<UIImage?> = .init(nil)
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    public func setUpHeroCell(viewModel: HeroesTableViewCellViewModel) {
        heroeNameLabel.text = viewModel.heroName
        heroeDescriptionLabel.text = viewModel.heroDescription
        heroThumbnail = viewModel.image
        heroThumbnail.bind { [weak self] (image) in
            guard let self = self else { return }
            self.heroeImage.image = image
        }
    }
}
