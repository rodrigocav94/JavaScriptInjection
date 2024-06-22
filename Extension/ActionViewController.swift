//
//  ActionViewController.swift
//  Extension
//
//  Created by Rodrigo Cavalcanti on 17/06/24.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    let dataSource = ActionViewControllerDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        dataSource.extensionContext = extensionContext
        dataSource.onAdd = { [weak self] in
            self?.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
        setupNavBar()
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.tintColor = .red
        title = "Select a script to run"
        
        let cancelButton = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancel)
        )
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(add)
        )
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func cancel() {
        extensionContext?.completeRequest(returningItems: [])
    }
    
    @objc func add() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "NewScript") as? NewScriptViewController {
            vc.dataSource = dataSource
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
