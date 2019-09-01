//
//  PostCell.swift
//  RedditClient
//
//  Created by German Buela on 01/09/2019.
//  Copyright © 2019 German Buela. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    static let cache = NSCache<NSString, UIImage>()
    
    @IBOutlet private weak var readIndicator: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var commentsLabel: UILabel!
    
    var post: Post? {
        didSet {
            updateData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectionColorView = UIView()
        selectionColorView.backgroundColor = UIColor.brown
        selectedBackgroundView = selectionColorView
    }
    
    private func updateData() {
        // FIXME: handle read indicator
        authorLabel.text = post?.author
        dateLabel.text = "\(post?.createdUtc ?? 0)" // FIXME: format date for display
        titleLabel.text = post?.title
        commentsLabel.text = "\(post?.numComments ?? 0) comments"
        loadImage(urlString: post?.thumbnailUrl)
    }
    
    private func loadImage(urlString: String?) {
        thumbnailImageView.image = nil
        
        guard let urlString = urlString else {
            return
        }
        
        if let image = PostCell.cache.object(forKey: urlString as NSString) {
            thumbnailImageView.image = image
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil,
                let data = data,
                let image = UIImage(data: data) else {
                    return
            }
            PostCell.cache.setObject(image, forKey: urlString as NSString)
            DispatchQueue.main.async {
                // make sure cell hasn't been recycled for another post!
                if urlString == self.post?.thumbnailUrl {
                    self.thumbnailImageView.image = image
                }
            }
        }
        task.resume()
    }
    
    @IBAction private func dismissTapped() {
        print("dismiss tapped") // FIXME: implement
    }
}

