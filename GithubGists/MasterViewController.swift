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
    //hold images indexed by their URL
    var imageCache = [String: UIImage?]()
    


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
        GitHubAPIManager.sharedInstance.fetchPublicGists { (result) in
            //check for an error here: if there is no error then copy the fetched array of gists to our local gists array
            guard result.error == nil else {
                self.handleLoadGistsError(result.error!)
                return
            }
            if let fetchedResults = result.value {
                self.gists = fetchedResults
            }
            self.tableView.reloadData()
            
        }
    }
    
    func handleLoadGistsError(_ error: Error) {
        // TODO: show error
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
        
        //set the image to nil in case the cell is being reused
        cell.imageView?.image = nil
        //check that we have a URL string for the image
        if let urlString = gist.ownerAvatarURL {
            //check cache to see if we already have it
            if let cachedImage = imageCache[urlString] {
                cell.imageView?.image = cachedImage
            }else {
                GitHubAPIManager.sharedInstance.imageFrom(urlString: urlString, completionHAndler: { (image, error) in
                    guard error == nil else {
                        print(error!)
                        return
                    }
                    //save image not to keep fetching it if they scroll
                    self.imageCache[urlString] = image
                    if let cellToUpdate = self.tableView?.cellForRow(at: indexPath) {
                        cellToUpdate.imageView?.image = image
                        //tell the cell that we’ve changed part of its view and it needs to redraw itself
                        cellToUpdate.setNeedsLayout()
                    }
                })
            }
            
        }
        
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

