//
//  MasterViewController.swift
//  RedditClient
//
//  Created by German Buela on 31/08/2019.
//  Copyright © 2019 German Buela. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, UISplitViewControllerDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let manager = RedditClientManager()
    private var fetchingNext = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Reddit Posts"
        splitViewController?.preferredDisplayMode = .allVisible
        splitViewController?.delegate = self
        
        manager.fetch(type: .top) { result in
            self.reloadData(result: result)
        }
    }
    
    private func reloadData(result: Result<ResponseModel,Error>) {
        switch result {
        case .success(_):
            tableView.reloadData()
        case .failure(let error):
            alert(text: error.localizedDescription)
        }
    }

    private func alert(text: String) {
        let alertController = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction private func dismissAllTapped() {
        print("dismissAllTapped") // FIXME: implement
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailViewController else {
            return
        }
        print("showing detail") // FIXME: implement
    }
}

extension MasterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("CURRENT POST COUNT \(manager.posts.count)")
        return manager.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // FIXME: implement
        let cell = UITableViewCell()
        cell.textLabel?.text = manager.posts[indexPath.row].title
        return cell
    }
}

// TODO: not performing segue automatically from storyboard connection
// find out why and remove this
extension MasterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: tableView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !fetchingNext else { return }
        let offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height))
        
        if offset >= 0 && offset <= 25 {
            fetchingNext = true
            manager.fetch(type: .next) { result in
                self.fetchingNext = false
                self.reloadData(result: result)
            }
        }
    }
}

