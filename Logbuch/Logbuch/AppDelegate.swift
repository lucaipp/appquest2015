import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        MagicalRecord.setLoggingLevel(.Off)
        MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreNamed("logbuch.sqlite")
        return true
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        let index = url.path!.startIndex.advancedBy(1)
        let solution = url.path!.substringFromIndex(index).stringByRemovingPercentEncoding!
        
        let logEntry = LogEntry.MR_createEntity()
        logEntry.timeStamp = NSDate()
        logEntry.solution = solution
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        return true
    }
}