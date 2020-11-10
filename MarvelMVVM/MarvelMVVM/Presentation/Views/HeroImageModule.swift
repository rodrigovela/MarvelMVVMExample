//
//  HeroImageModule.swift
//  MarvelMVVMExample
//
//  Created by Ivan F Garcia S on 09/11/20.
//  Copyright © 2020 Ivan F Garcia S. All rights reserved.
//

import UIKit

class HeroImageModule: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet weak var heroView: UIView!
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView! {
        didSet {
            blurView.alpha = 0
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Constraints
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleCentetConstraint: NSLayoutConstraint!
    
    // MARK: - Vars & Constants

    struct Constants {
        static let ModuleHeight: CGFloat = 240
        static let NavBarHeightSize: CGFloat = 64
        static let LimitForHeaderLabel: CGFloat = 10
        static let AdjustedAlphaValue: CGFloat = 1
        static let headerModuleIdentifier: String = "HeroImageModule"
    }
    
    var kMaxOffset: CGFloat {
        return HeroImageModule.Constants.ModuleHeight
    }
    
    var goToDeckEnabled: Bool {
        return blurView.alpha != 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle(for: type(of: self)).loadNibNamed(String(describing: HeroImageModule.self), owner: self, options: nil)

        addSubview(heroView)
        heroView.frame = self.bounds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI() {
        titleLabel.text = "Heroes"
    }
    
    func updateSize(offset: CGFloat) {
        viewHeightConstraint.constant = (kMaxOffset - offset > Constants.NavBarHeightSize) ? kMaxOffset - offset : Constants.NavBarHeightSize
        adaptView(size: viewHeightConstraint.constant)
        titleCentetConstraint.constant = (kMaxOffset - offset > Constants.LimitForHeaderLabel) ? kMaxOffset - offset : Constants.LimitForHeaderLabel
    }
    
    func adaptView(size: CGFloat) {
        guard size < kMaxOffset - Constants.LimitForHeaderLabel else {
            blurView.alpha = 0
            return
        }
        let adjustedSize = Constants.AdjustedAlphaValue - ((size - Constants.NavBarHeightSize) / (kMaxOffset))
        blurView.alpha = adjustedSize
    }
}
