//
//  AuthorizationCarouselCollectionViewCell.swift
//  Reddit Chile Memes
//
//  Created by Freddy Silva on 15/5/22.
//

import UIKit

protocol AuthorizationCarouselCollectionViewCellDelegate: AnyObject {
    func didTapAuthorization(item: AuthorizationCarousel.Item)
    func didTapCancel(item: AuthorizationCarousel.Item)
}

class AuthorizationCarouselCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var authorizationImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var authorizationButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    static let reuseIdentifier = "AuthorizationCarouselCellId"
    
    var delegate: AuthorizationCarouselCollectionViewCellDelegate?
    
    private var item: AuthorizationCarousel.Item?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - Methods
    func setupAutorizationCarouselCell(item: AuthorizationCarousel.Item) {
        self.item = item
        
        authorizationImageView.image = UIImage(named: item.image)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        authorizationButton.setTitle(item.titleButton, for: .normal)
        cancelButton.setTitle("com.AuthorizationCarousel.button.title.cancel".localized(), for: .normal)
    }

    // MARK: - Actions
    @IBAction func didTapAuthorization(_ sender: Any) {
        guard let item = item else { return }
        
        delegate?.didTapAuthorization(item: item)
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        guard let item = item else { return }
        
        delegate?.didTapCancel(item: item)
    }
}
