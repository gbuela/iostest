//
//  DetailViewController.swift
//  RedditClient
//
//  Created by German Buela on 31/08/2019.
//  Copyright © 2019 German Buela. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private var imageHeightConstraint: NSLayoutConstraint!
    
    var post: Post? {
        didSet {
            updateData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: figure out why master is not appearing on swipe from left on iPad
        // Using nav bar on detail instead
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapRecognizer)
        
        updateData()
    }
    
    private func updateData() {
        guard isViewLoaded else { return }
        
        authorLabel.text = post?.author
        titleLabel.text = post?.title
        
        if let imageUrlString = imageUrl(),
            let url = URL(string: imageUrlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        // TODO: image view has fixed height, make it adaptable
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    private func imageUrl() -> String? {
        guard let url = post?.url else { return post?.thumbnailUrl }
        // TODO: is this an image link? not sure how this is determined
        return url.hasSuffix(".jpg") || url.hasSuffix(".gif") || url.hasSuffix(".png") ? url : nil
    }
    
    @objc private func imageTapped() {
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            simpleAlert(text: "Could not save image")
        } else {
            simpleAlert(text: "Image saved!")
        }
    }
    
}
