import Foundation
import CoreData

@objc(LogEntry)
class LogEntry: NSManagedObject {
    @NSManaged var timeStamp: NSDate!
    @NSManaged var solution: String!
}
