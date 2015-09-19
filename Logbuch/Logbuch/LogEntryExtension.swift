import Foundation

extension LogEntry {
    var formattedTimeStamp: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY HH:mm"
        return dateFormatter.stringFromDate(timeStamp)
    }
    
    var taskName: String {
        if let json = getJSON() {
            if let name = json["task"] as? String {
                return name
            }
        }
        return "Unknown"
    }
    
    private func getJSON() -> Dictionary<String, AnyObject>? {
        let data = solution.dataUsingEncoding(NSUTF8StringEncoding)
        if let data = data {
            do {
                let jsonObj = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                return jsonObj as? Dictionary<String, AnyObject>
            } catch _ {
            }
        }
        return nil
    }
    
    func isValid() -> Bool {
        if let json = getJSON() {
            return isValidFormat(json)
        }
        return false
    }
    
    private func isValidFormat(json: Dictionary<String, AnyObject>) -> Bool {
        let isValidTask = isMetalldetektor(json)
                        || isGroessenmesser(json)
                        || isSchatzkarte(json)
                        || isSchrittzaehler(json)
                        || isPixelmaler(json)
        if !isValidTask {
            print("No task detected in log entry.")
        }
        return isValidTask
    }
    
    private func isValidTask(json: Dictionary<String, AnyObject>, named taskName: String) -> Bool {
        if let name = json["task"] as? String {
            return name == taskName
        }
        return false
    }
    
    private func isMetalldetektor(json: Dictionary<String, AnyObject>) -> Bool {
        if !isValidTask(json, named: "Metalldetektor") {
            return false
        }
        
        if json["solution"] == nil {
            print("Metalldetektor task does not have 'solution' property.")
            return false
        }
        
        return true
    }
    
    private func isGroessenmesser(json: Dictionary<String, AnyObject>) -> Bool {
        if !isValidTask(json, named: "Groessenmesser") {
            return false
        }
        
        if json["object"] == nil || json["height"] == nil {
            print("Groessenmesser task does not have 'object' and 'height' properties.")
            return false
        }
        
        return true
    }
    
    private func isSchatzkarte(json: Dictionary<String, AnyObject>) -> Bool {
        if !isValidTask(json, named: "Schatzkarte") {
            return false
        }
        
        if let points = json["points"] as? Array<AnyObject> {
            for point in points {
                if let point = point as? Dictionary<String, AnyObject> {
                    if point["lat"] == nil || point["lon"] == nil {
                        print("Schatzkarte 'point' does not have 'lat' and 'lon' properties.")
                        return false
                    }
                    
                    if !(point["lat"] is Int && point["lon"] is Int) {
                        print("Schatzkarte 'lat' and 'lon' properties are not ints.")
                        return false
                    }
                }
            }
        } else {
            print("Schatzkarte task does not have 'points' property.")
            return false
        }
        return true
    }
    
    private func isSchrittzaehler(json: Dictionary<String, AnyObject>) -> Bool {
        if !isValidTask(json, named: "Schrittzaehler") {
            return false
        }
        
        if json["startStation"] == nil || json["endStation"] == nil {
            print("Schrittzaehler does not have 'startStation' and 'endStation' properties.")
            return false
        }
                    
        if !(json["startStation"] is Int && json["endStation"] is Int) {
            print("Schrittzaehler 'startStation' and 'endStation' properties are not ints.")
            return false
        }
        return true
    }
    
    private func isPixelmaler(json: Dictionary<String, AnyObject>) -> Bool {
        if !isValidTask(json, named: "Pixelmaler") {
            return false
        }
        
        if let pixels = json["pixels"] as? Array<AnyObject> {
            for pixel in pixels {
                if let pixel = pixel as? Dictionary<String, AnyObject> {
                    if pixel["x"] == nil || pixel["y"] == nil || pixel["color"] == nil {
                        print("Pixelmaler 'pixels' child does does not have 'x', 'y' and 'color' properties.")
                        return false
                    }
                    /*
                    boolean hasColorsInExpectedFormat = object.getString("color").matches("#.{6}FF")
                    || object.getString("color").matches("#FF.{6}");
                    if (!hasColorsInExpectedFormat) {
                    Log.i("validation", "Pixelmaler 'color' does not match format.");
                    return false;
                    }
                    */
                } else {
                    print("Pixelmaler 'pixels' child is not a JSON object.")
                    return false
                }
            }
        } else {
            print("Pixelmaler does not have 'pixels' property.")
            return false
        }
        return true
    }
}