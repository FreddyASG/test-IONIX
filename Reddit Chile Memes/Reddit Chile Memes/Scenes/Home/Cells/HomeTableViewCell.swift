//
//  HomeTableViewCell.swift
//  Reddit Chile Memes
//
//  Created by Freddy Silva on 16/5/22.
//

import UIKit
import Kingfisher

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    static let reuseIdentifier = "HomeTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    func setupHomeCell(image: String, score: Int, title: String, comments: Int) {
        
        if !image.isEmpty, let imageUrl = URL(string: image) {
            postImageView.kf.indicatorType = .activity
            postImageView.kf.setImage(with: imageUrl,
                                      placeholder: UIImage(named: "placeholder-image"),
                                      options: nil) { _ in
            }
        } else {
            postImageView.image = UIImage(named: "placeholder-image")
        }
        
        scoreLabel.text = "\(score)"
        titleLabel.text = title
        commentsLabel.text = "\(comments)"
        
    }
    
}
