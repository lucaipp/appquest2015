import UIKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, RMMapViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //Definition der Variablen und Konstanten
    let kAccessToken = "sk.eyJ1IjoidG9uaXN1dGVyIiwiYSI6ImNpZmptbnhxYTAxMGR0ZWx4ZjFhejdkMzEifQ.4HxuC8B4MW_slik23J9NqQ"
    let kMapID = "tonisuter.cife1ku4000gmtaknuv49tvwc"
    let kHsrCoordinate = CLLocationCoordinate2DMake(47.223252, 8.817011)
    var kMapView: RMMapView!
    let kLocationManager = CLLocationManager()
    var kCurrentLocationMarker = RMPointAnnotation()
    var kMarkerArray: [RMPointAnnotation] = []
    let kDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MapView-Konfiguration
        RMConfiguration.sharedInstance().accessToken = kAccessToken
        kMapView = RMMapView(frame: self.view.bounds, andTilesource: RMMapboxSource(mapID: kMapID)!)
        kMapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        kMapView.delegate = self
        kMapView.userTrackingMode = RMUserTrackingModeFollow
        
        self.view.addSubview(kMapView)
        
        //LocationManager-Konfiguration
        kLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        kLocationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            kLocationManager.startUpdatingLocation()
        }
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            kLocationManager.requestAlwaysAuthorization()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        saveMarkerArray()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        kMapView.zoom = 16
        kMapView.removeAllAnnotations()
        kMarkerArray = []
        
        if kDefaults.objectForKey("markerArray") != nil {
            let markerArray = kDefaults.objectForKey("markerArray") as! NSArray
            for(var i: Int = 0; i < markerArray.count; i++) {
                var pointArray = NSArray()
                pointArray = markerArray[i] as! NSArray
                kMarkerArray.append(RMPointAnnotation(mapView: kMapView, coordinate: CLLocationCoordinate2D(latitude: Double(pointArray[0] as! NSNumber), longitude: Double(pointArray[1] as! NSNumber)), andTitle: String(i)))
            }
        }
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
        let cell = UITableViewCell()
        cell.textLabel?.text = kMarkerArray[indexPath.row].title
        
        return cell
    }
    
    //Löschen eines Markers
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let deleteAlert = UIAlertController()
        deleteAlert.title = "Delete Selected Marker?"
        deleteAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            let title = tableView.cellForRowAtIndexPath(indexPath)!.textLabel?.text
            if let index = self.kMarkerArray.indexOf({ $0.title == title }) {
                self.kMapView.removeAnnotation(self.kMarkerArray[index])
                self.kMarkerArray.removeAtIndex(index)
                tableView.reloadData()
                self.saveMarkerArray()
            }
        }))
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            return
        }))
        presentViewController(deleteAlert, animated: true, completion: nil)
    }
    
    func saveMarkerArray() {
        if kMarkerArray.count > 0 {
            let markerArray = NSMutableArray()
            for(var i: Int = 0; i < kMarkerArray.count; i++) {
                let pointArray = NSMutableArray()
                pointArray.addObject(Double(kMarkerArray[i].coordinate.latitude))
                pointArray.addObject(Double(kMarkerArray[i].coordinate.longitude))
                markerArray.addObject(pointArray)
            }
            kDefaults.setObject(markerArray, forKey: "markerArray")
        }
        else {
            kDefaults.removeObjectForKey("markerArray")
        }
        kDefaults.synchronize()
    }
    
    //Actions bei Klick auf ToolBar-Buttons
    @IBAction func saveCurrentPosition(sender: AnyObject) {
        let newMarker = RMPointAnnotation(mapView: kMapView, coordinate: kCurrentLocationMarker.coordinate, andTitle: String(kMarkerArray.count))
        kMarkerArray.append(newMarker)
        kMapView.addAnnotation(newMarker)
        saveMarkerArray()
    }
    
    @IBAction func locate(sender: AnyObject) {
        kMapView.centerCoordinate = kCurrentLocationMarker.coordinate
        kMapView.zoom = 16
    }
    
    @IBAction func showMarkers(sender: AnyObject) {
        let tableViewController = UITableViewController()
        
        tableViewController.tableView.dataSource = self
        tableViewController.tableView.delegate = self
        
        self.showViewController(tableViewController, sender: self)
    }
    
    @IBAction func logSolution(sender: AnyObject) {
        let solutionLogger = SolutionLogger(viewController: self)
        
        var points: String = "["
        for(var i: Int = 0; i < kMarkerArray.count; i++) {
            let lat: Double = Double(kMarkerArray[i].coordinate.latitude * pow(10,6))
            let lon: Double = Double(kMarkerArray[i].coordinate.longitude * pow(10,6))
            points += "{\"lat\": \(lat),\"lon\": \(lon)},"
        }
        points += "]"
        
        solutionLogger.logSolution("{\"points\":" + points + ",\"task\":\"Schatzkarte\"}")
    }
}
