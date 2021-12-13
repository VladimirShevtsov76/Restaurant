//
//  MenuTableTableViewController.swift
//  Restaurant
//
//  Created by Vladimir Shevtsov on 07.12.2021.
//
//  View controller for the screen after the category was selected

import UIKit

class MenuTableViewController: UITableViewController {
    /// The category name we should receive from CategoryTableViewController
    var category: String!
    
    /// Array of menu items to be displayed in the table
    var menuItems = [MenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Table title is capitalized category name
        title = category.capitalized
        
        // Load the menu for a given category
        MenuController.shared.fetchMenuItems(categoryName: category) { (menuItems) in
            // if we indeed got the menu items
            if let menuItems = menuItems {
                // update the interface
                self.updateUI(with: menuItems)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // fit the detail (price) labels
        fitDetailLabels()
    }
    
    override func viewWillLayoutSubviews() {
        // fit the detail (price) labels
        fitDetailLabels()
    }
    
    /// Set the property and update the interface
    func updateUI(with menuItems: [MenuItem]) {
        // have to go back to main queue from background queue where network requests are exectured
        DispatchQueue.main.async {
            // remember the menu items for diplaying in the table
            self.menuItems = menuItems
            
            // reload the table
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // there is only one section
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // the number of cells is equal to the size of menu items array
        return menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // reuse the menu list prototype cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCellIdentifier", for: indexPath)

        // configure the cell with menu list data
        configure(cell: cell, forItemAt: indexPath)

        return cell
    }
    
    /// Configure the table cell with menu list data
    /// - parameters:
    ///     - cell: The cell to be configured
    ///     - indexPath: An index path locating a row in tableView
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        // get the needed menu item for corresponding table row
        let menuItem               = menuItems[indexPath.row]
        
        // the left label of the cell should display the name of the item
        cell.textLabel?.text       = menuItem.name
        
        // the right label displays the price along with currency symbol
        cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
        
        // fetch the image from the server
        MenuController.shared.fetchImage(url: menuItem.imageURL) { image in
            // check that the image was fetched successfully
            guard let image = image else { return }
            
            // return to main thread after the network request in background
            DispatchQueue.main.async {
                // get the current index path
                guard let currentIndexPath = self.tableView.indexPath(for: cell) else { return }
                
                // check if the cell was not yet recycled
                guard currentIndexPath == indexPath else { return }
                
                // set the thumbnail image
                cell.imageView?.image = image
                
                // fit the image to the cell
                self.fitImage(in: cell)
            }
        }
    }
    
    // adjust the cell height to make images look better
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    
    // MARK: - Navigation

    /// Passes MenuItem to MenuItemDetailViewController before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // checks this segue is from MenuTableViewController to MenuItemDetailViewController
        if segue.identifier == "MenuDetailSegue" {
            // we can safely downcast to MenuItemDetailViewController
            let menuItemDetailViewController = segue.destination as! MenuItemDetailViewController
            
            // selected cell's row is the index for array of menuItems
            let index = tableView.indexPathForSelectedRow!.row
            
            // pass selected menuItem to destination MenuItemDetailViewController
            menuItemDetailViewController.menuItem = menuItems[index]
        }
    }

}
