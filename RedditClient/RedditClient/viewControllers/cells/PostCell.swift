//
//  PostCell.swift
//  RedditClient
//
//  Created by German Buela on 01/09/2019.
//  Copyright © 2019 German Buela. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
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
    
    private func updateData() {
        // FIXME: handle read indicator
        authorLabel.text = post?.author
        dateLabel.text = "\(post?.createdUtc ?? 0)" // FIXME: format date for display
        titleLabel.text = post?.title
        commentsLabel.text = "\(post?.numComments ?? 0) comments"
        // FIXME: load image
    }
    
    @IBAction private func dismissTapped() {
        print("dismiss tapped") // FIXME: implement
    }
}

