//
//  NewScriptViewController.swift
//  Extension
//
//  Created by Rodrigo Cavalcanti on 21/06/24.
//

import UIKit

class NewScriptViewController: UITableViewController {
    var dataSource: ActionViewControllerDataSource?
    var nameCell: NameCell?
    var scripCell: ScriptCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tableView.contentInset.top = 30
        setupNavBar()
    }
    
    func setupNavBar() {
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(done)
        )
        
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func done() {
        guard let name = nameCell?.textField.text, let script = scripCell?.textView.text else { return }
        
        if !name.isEmpty && !script.isEmpty {
            let newScript = SavedScript(name: name, script: script)
            dataSource?.scripts.insert(newScript, at: 0)
            dataSource?.onAdd?()
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Table view data source
    func registerCells() {
        tableView.register(UINib(nibName: "NameCell", bundle: nil), forCellReuseIdentifier: "NameCell")
        tableView.register(UINib(nibName: "ScriptCell", bundle: nil), forCellReuseIdentifier: "ScriptCell")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! NameCell
            nameCell = cell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScriptCell", for: indexPath) as! ScriptCell
            scripCell = cell
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            "Name"
        case 1:
            "Script"
        default:
            ""
        }
    }
}
