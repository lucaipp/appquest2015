import UIKit

class PixelGridView: UIView {
    let gridSize: Int
    let gridColor: UIColor
    var squares = [[UIView]]()

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
        
        // TODO: set up square-views and position them one after another to form a grid --> DONE
        for var y = 0; y < gridSize; y++ {
            var lineSquares = [UIView]()
            for var x = 0; x < gridSize; x++ {
                let square = UIView(frame: CGRect(x: ((Int(screenSize.width) - (gridSize * squareSize)) / 2) + (x * squareSize), y: (y * squareSize), width: squareSize, height: squareSize))
                square.layer.borderWidth = 1.0
                square.layer.borderColor = gridColor.CGColor
                square.backgroundColor = UIColor(rgba: "#FFFFFFFF")
                addSubview(square)
                lineSquares.append(square)
            }
            squares.append(lineSquares)
        }
    }
    
    func colorizeSquaresOnPath(path: [CGPoint], color: UIColor) {
        for currentPoint in path {
            colorizeSquares(color) { square in
                return CGRectContainsPoint(square.frame, currentPoint)
            }
        }
    }
    
    private func colorizeSquares(color: UIColor, condition:(UIView) -> (Bool) ){
        // TODO: set the background color for all squares for which condition(square) == true -> DONE
        for var x = 0; x < squares.count; x++ {
            for var y = 0; y < squares[x].count; y++ {
                if condition(squares[x][y]) == true {
                    squares[x][y].backgroundColor = color
                }
            }
        }
    }

    func clearSquares() {
        // TODO: clear the background color of all squares -> DONE
        for var x = 0; x < squares.count; x++ {
            for var y = 0; y < squares[x].count; y++ {
                squares[x][y].backgroundColor = UIColor(rgba: "#FFFFFFFF")
            }
        }
    }
}

