//
//  HeroesTableViewCell.swift
//  MarvelMVVMExample
//
//  Created by Ivan F Garcia S on 09/11/20.
//  Copyright © 2020 Ivan F Garcia S. All rights reserved.
//

import UIKit

class HeroesTableViewCell: UITableViewCell {
    
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    public func setUpHeroCell(image: String, heroName: String, heroDescription: String) {
        heroeNameLabel.text = heroName
        heroeDescriptionLabel.text = heroDescription
        setImage(url: image)
    }
    
    private func setImage(url: String?) {
        guard let stringUrl = url, let imageUrl = URL(string: stringUrl) else {
            return
        }
        // set Image from server
  
    }
}
