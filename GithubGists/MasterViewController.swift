//
//  MasterViewController.swift
//  GithubGists
//
//  Created by Polina Fiksson on 13/02/2018.
//  Copyright © 2018 PolinaFiksson. All rights reserved.
//

import UIKit
import Alamofire

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    //array of gists
    var gists = [Gist]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //buttons for the nav bar
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        //a connection to the detailed VC to use it later
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    //load the data when the view gets shown
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       loadGists()
        
        
        
    }
    //MARK: Retrieve model objects
    func loadGists() {
        // GitHubAPIManager.sharedInstance.printPublicGists()
        let gist1 = Gist()
        gist1.description = "The first gist"
        gist1.ownerLogin = "gist1Owner"
        let gist2 = Gist()
        gist2.description = "The second gist"
        gist2.ownerLogin = "gist2Owner"
        let gist3 = Gist()
        gist3.description = "The third gist"
        gist3.ownerLogin = "gist3Owner"
        gists = [gist1, gist2, gist3]
        // Tell the table view to reload
        self.tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func insertNewObject(_ sender: Any) {
        let alert = UIAlertController(title: "Not Implemented",
                                      message: "Can't create new gists yet, will implement later",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let gist = gists[indexPath.row]
                if let controller = (segue.destination as! UINavigationController).topViewController as? DetailViewController {
                    controller.detailItem = gist
                    controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
                
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let gist = gists[indexPath.row]
        cell.textLabel!.text = gist.description
        cell.detailTextLabel?.text = gist.ownerLogin
        // TODO: set cell.imageView to display image at gist.ownerAvatarURL
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            gists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

