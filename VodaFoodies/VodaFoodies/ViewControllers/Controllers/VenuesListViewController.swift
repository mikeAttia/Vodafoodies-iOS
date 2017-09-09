//
//  VenuesListViewController.swift
//  VodaFoodies
//
//  Created by Michael Attia on 9/8/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit
import Kingfisher

class VenuesListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Constants
    let cellIdentifier = "venueItem"
    let pageTitle = "Venues"
    let venuePlaceHolder = "venue"
    let selectSegueID = "selectedVenue"
    var venues: [Venue] = []
    var selectedVenueIndex = 0
    
    @IBOutlet weak var contentTable: UITableView!
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = pageTitle
        contentTable.delegate = self
        contentTable.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO: View the loading indicator and make the request
        let req = Request.venue(.listedVenues(callBack: handleRequestResult))
        DataStore.shared.getData(req: req)
    }
    
    private func handleRequestResult(venues: [Venue]?, err:RequestError? ){
        
        //TODO: Dismiss the loading indicator
        
        guard let venuesList = venues else{
            if let error = err{
                // TODO: Show Error message to the user
                print(error.error)
            }
            return
        }
        
        self.venues = venuesList
        self.contentTable.reloadData()
    }
    
    
    // MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        cell?.textLabel?.text = venues[indexPath.row].name
        cell?.imageView?.kf.indicatorType = .activity
        cell?.imageView?.kf.setImage(with: URL(string: venues[indexPath.row].img), placeholder: UIImage(named: venuePlaceHolder), options: nil, progressBlock: nil, completionHandler: nil)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedVenueIndex = indexPath.row
        performSegue(withIdentifier: selectSegueID, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let menuView = segue.destination as? MenuViewController{
            menuView.venue = venues[selectedVenueIndex]
            menuView.owner = true
        }
    }
    
    //MARK: - View Actions
    
    @IBAction func cancelOrder(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    

}
