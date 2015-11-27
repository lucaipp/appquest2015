import UIKit

class PixelGridView: UIView {
    let gridSize: Int
    let gridColor: UIColor
    var squares = [UIView]()

    init(gridSize: Int, gridColor: UIColor) {
        self.gridSize = gridSize
        self.gridColor = gridColor
        super.init(frame:CGRectZero)
        renderGrid()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func renderGrid() {
        let screenSize = UIScreen.mainScreen().bounds.size
        let smallerSide = min(screenSize.width, screenSize.height)
        let squareSize = Int(smallerSide) / gridSize
        
        // TODO: set up square-views and position them one after another to form a grid
    }
    
    func colorizeSquaresOnPath(path: [CGPoint], color: UIColor) {
        var previousPoint:CGPoint?
        for currentPoint in path {
            if let lineStart = previousPoint {
                colorizeSquares(color) { square in
                    return false // TODO: return whether the square's frame has been intersected by the drawn path segment. Use the LineIntersection class.
                }
            } else {
                /* For the first point we only check if the point is contained in a view's coordinates rect */
                colorizeSquares(color) { square in
                    return CGRectContainsPoint(square.frame, currentPoint)
                }
            }
            previousPoint = currentPoint
        }
    }
    
    private func colorizeSquares(color: UIColor, condition:(UIView) -> (Bool) ){
        // TODO: set the background color for all squares for which condition(square) == true
    }

    func clearSquares() {
        // TODO: clear the background color of all squares
    }
}

