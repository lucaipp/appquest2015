
class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    lazy var fetchedResultsController: NSFetchedResultsController = {
        return LogEntry.MR_fetchAllSortedBy("timeStamp", ascending: false, withPredicate: nil, groupBy: nil, delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = fetchedResultsController.sections![section].numberOfObjects
        if numberOfRows == 0 && tableView.backgroundView == nil {
            let emptyMessageLabel = UILabel()
            emptyMessageLabel.text = "Es sind noch keine\nEinträge im Logbuch vorhanden."
            emptyMessageLabel.textAlignment = .Center
            emptyMessageLabel.textColor = UIColor(red: 0.2, green: 0.4, blue: 0.62, alpha: 1.0)
            emptyMessageLabel.textColor = UIColor.blackColor()
            emptyMessageLabel.font = UIFont.boldSystemFontOfSize(16)
            emptyMessageLabel.numberOfLines = 0
            tableView.backgroundView = emptyMessageLabel
            tableView.separatorStyle = .None
        } else if numberOfRows > 0 {
            tableView.backgroundView = nil
            tableView.separatorStyle = .SingleLine
        }
        return numberOfRows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LogEntryCell", forIndexPath: indexPath)
        configureCell(cell, atIndexPath:indexPath)
        return cell
    }
    
    private func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let logEntry = fetchedResultsController.objectAtIndexPath(indexPath) as! LogEntry
        let logEntryCell = cell as! LogEntryCell
        logEntryCell.timeStampLabel.text = logEntry.formattedTimeStamp
        logEntryCell.solutionLabel.text = logEntry.solution
        logEntryCell.taskNameLabel.text = logEntry.taskName
        let icon = logEntry.isValid() ? UIImage(named:"Valid") : UIImage(named: "Invalid")
        logEntryCell.validityIcon.image = icon
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            fetchedResultsController.objectAtIndexPath(indexPath).MR_deleteEntity()
            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PresentUpload" {
            let navController = segue.destinationViewController as! UINavigationController
            let uploadViewController = navController.topViewController as! UploadViewController
            uploadViewController.logEntries = self.fetchedResultsController.fetchedObjects as! [LogEntry]
        } else if segue.identifier == "PushDetail" {
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.logEntry = fetchedResultsController.objectAtIndexPath(tableView.indexPathForSelectedRow!) as! LogEntry
        }
    }

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch(type) {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Update:
            configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}