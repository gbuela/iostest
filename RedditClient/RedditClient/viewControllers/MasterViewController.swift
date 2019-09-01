//
//  MasterViewController.swift
//  RedditClient
//
//  Created by German Buela on 31/08/2019.
//  Copyright © 2019 German Buela. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let manager = RedditClientManager()
    private var fetchingNext = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Reddit Posts"
        splitViewController?.preferredDisplayMode = .primaryOverlay
        splitViewController?.delegate = self
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(MasterViewController.doRefresh(_:)),
                                  for: UIControl.Event.valueChanged)
        tableView.addSubview(refresh)
        
        manager.fetch(type: .top) { result in
            self.reloadData(result: result)
        }
    }
    
    private func reloadData(result: Result<ResponseModel,Error>) {
        switch result {
        case .success(_):
            tableView.reloadData()
        case .failure(let error):
            simpleAlert(text: error.localizedDescription)
        }
    }

    @IBAction private func dismissAllTapped() {
        print("dismissAllTapped") // FIXME: implement
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let index = tableView.indexPathForSelectedRow?.row,
            let navVC = segue.destination as? UINavigationController,
            let detailVC = navVC.viewControllers.first as? DetailViewController else {
            return
        }
        detailVC.post = manager.posts[index]
    }
    
    @objc private func doRefresh(_ refreshControl: UIRefreshControl) {
        manager.fetch(type: .top) { result in
            refreshControl.endRefreshing()
            self.reloadData(result: result)
        }
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

extension MasterViewController: UITableViewDelegate {
    // TODO: not performing segue automatically from storyboard connection
    // find out why and remove this
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

extension MasterViewController: UISplitViewControllerDelegate {
    // prevent displaying detail only when no item has been selected yet
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        guard let navVC = secondaryViewController as? UINavigationController,
            let detailVC = navVC.viewControllers.first as? DetailViewController,
            detailVC.post != nil else {
                return true
        }
        return false
    }
}
