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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Reddit Posts"
        splitViewController?.preferredDisplayMode = .allVisible
        splitViewController?.delegate = self
        
        manager.fetch(type: .top) { result in
            switch result {
            case .success(let responseModel):
                self.alert(text: responseModel.data.children[0].data.title)
            case .failure(let error):
                self.alert(text: error.localizedDescription)
            }
        }
    }

    private func alert(text: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: nil, message: text, preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
        }
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
        return 1 // FIXME: implement
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // FIXME: implement
        let cell = UITableViewCell()
        cell.textLabel?.text = "test cell"
        return cell
    }
}

// TODO: not performing segue automatically from storyboard connection
// find out why and remove this
extension MasterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: tableView)
    }
}

