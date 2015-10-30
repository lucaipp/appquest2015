import UIKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, RMMapViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //Definition der Variablen und Konstanten
    let kAccessToken = "sk.eyJ1IjoidG9uaXN1dGVyIiwiYSI6ImNpZmptbnhxYTAxMGR0ZWx4ZjFhejdkMzEifQ.4HxuC8B4MW_slik23J9NqQ"
    let kMapID = "tonisuter.cife1ku4000gmtaknuv49tvwc"
    let kHsrCoordinate = CLLocationCoordinate2DMake(47.223252, 8.817011)
    var kMapView: RMMapView!
    let kLocationManager = CLLocationManager()
    var kCurrentLocationMarker: RMPointAnnotation!
    var kMarkerArray: [RMPointAnnotation] = []
    let kDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RMConfiguration.sharedInstance().accessToken = kAccessToken
        kMapView = RMMapView(frame: self.view.bounds, andTilesource: RMMapboxSource(mapID: kMapID)!)
        kMapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        kMapView.delegate = self
        
        self.view.addSubview(kMapView)
        
        kCurrentLocationMarker = RMPointAnnotation()
        kCurrentLocationMarker.mapView = kMapView
        kCurrentLocationMarker.title = "My Location"
        
        kMapView.addAnnotation(kCurrentLocationMarker)
        
        kLocationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            kLocationManager.startUpdatingLocation()
        }
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            kLocationManager.requestAlwaysAuthorization()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        //TODO: Array in NSUserDefaults speichern
        
        kDefaults.synchronize()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        kMapView.zoom = 16
        
        //TODO: Array aus NSUserDefaults laden
        
        if kMarkerArray.count > 0 {
            for(var i: Int = 0; i < kMarkerArray.count; i++) {
                kMapView.addAnnotation(kMarkerArray[i])
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            kLocationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        var refresh = false
        
        if kCurrentLocationMarker.coordinate.longitude == 0.0 && kCurrentLocationMarker.coordinate.latitude == 0.0 {
            refresh = true
        }
        
        kCurrentLocationMarker.coordinate = CLLocationCoordinate2DMake(coord.latitude, coord.longitude)
        
        if refresh {
            locate(self)
        }
    }
    
    //TableView für die Marker
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kMarkerArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        cell.textLabel?.text = kMarkerArray[indexPath.row].title
        
        return cell
    }
    
    //Löschen eines Markers
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let deleteAlert = UIAlertController()
        deleteAlert.title = "Delete Selected Marker?"
        deleteAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            for(var i: Int = 0; i < self.kMarkerArray.count; i++) {
                if self.kMarkerArray[i].title == tableView.cellForRowAtIndexPath(indexPath)!.textLabel?.text {
                    self.kMapView.removeAnnotation(self.kMarkerArray[i])
                    self.kMarkerArray.removeAtIndex(i)
                    tableView.reloadData()
                }
            }
        }))
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            return
        }))
        presentViewController(deleteAlert, animated: true, completion: nil)
    }
    
    //Actions bei Klick auf ToolBar-Buttons
    @IBAction func saveCurrentPosition(sender: AnyObject) {
        let newMarker = RMPointAnnotation()
        newMarker.mapView = kMapView
        newMarker.title = String(kMarkerArray.count + 1)
        newMarker.coordinate = kCurrentLocationMarker.coordinate
        //TODO: Symbol des Markers verändern
        
        kMarkerArray.append(newMarker)
        kMapView.addAnnotation(newMarker)
    }
    
    @IBAction func locate(sender: AnyObject) {
        kMapView.centerCoordinate = kCurrentLocationMarker.coordinate
        kMapView.zoom = 16
    }
    
    @IBAction func showMarkers(sender: AnyObject) {
        let tableViewController: UITableViewController = UITableViewController()
        
        tableViewController.tableView.dataSource = self
        tableViewController.tableView.delegate = self
        
        self.showViewController(tableViewController, sender: self)
    }
    
    @IBAction func logSolution(sender: AnyObject) {
        //TODO: Richtige Formatierung
        var json = [String:String]()
        json["task"] = "Schatzkarte"
        
        var points: String = "["
        for(var i: Int = 0; i < kMarkerArray.count; i++) {
            if i > 0 {
                points += ","
            }
            points += String("{\"lat\": \(kMarkerArray[i].coordinate.latitude * pow(10, 6)), \"lon\": \(kMarkerArray[i].coordinate.longitude * pow(10, 6))}")
        }
        points += "]"
        json["points"] = points
        let solutionLogger = SolutionLogger(viewController: self)
        let solutionStr = solutionLogger.JSONStringify(json)
        solutionLogger.logSolution(solutionStr)
    }
}
