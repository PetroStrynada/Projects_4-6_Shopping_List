//
//  ViewController.swift
//  Shopping_List
//
//  Created by Petro Strynada on 21.06.2023.
//

import UIKit

class ViewController: UITableViewController {

    var itemsForShoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Shopping List"

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))

        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(newList))
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolbarItems = [refresh, spacer, add]
        navigationController?.isToolbarHidden = false

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsForShoppingList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = itemsForShoppingList[indexPath.row]
        return cell
    }

    @objc func share() {
        let list = itemsForShoppingList.joined(separator: "\n")

        let activityItems: [Any] = [list]

        let vc = UIActivityViewController(activityItems: activityItems, applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem //For iPad
        present(vc, animated: true)

    }

    @objc func newList() {
        let ac = UIAlertController(title: "Refresh your list?", message: nil, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Submit", style: .destructive) { _ in
            self.itemsForShoppingList = []
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }

    @objc func addNewItem() {
        let ac = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let item = ac?.textFields?[0].text else { return }
            self?.submit(item)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .default)

        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }

    func submit(_ item: String) {

        guard !isEmpty(word: item) else {
            return showErrorMessage(title: "The text field is empty",
                                    message: "Please type the word")
        }

        itemsForShoppingList.insert(item, at: 0)

        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)

        func showErrorMessage(title errorTitle: String, message errorMessage: String) {
            let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }

    }

    func isEmpty(word: String) -> Bool {
        guard word.isEmpty else { return false }
        return true
    }



}


