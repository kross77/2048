/**
 * Created by Administator on 13.10.14.
 */
package core {
import core.object.Cell;
import core.object.Tile;

public class GameManager {
    public var size:int;
    public var startTiles:int = 2;
    public var inputManager:IInputManager;
    public var storageManager:IStorageManager;
    public var actuator:IActuator;
    public var grid:Grid;
    public var score:int;
    public var over:Boolean;
    public var won:Boolean;
    public var keepPlaying:Boolean;
    public function GameManager() {

    }

    public function restart():void
    {
        storageManager.clearGameState();
        actuator.continueGame();
        setup();

    }

    public function setup():void {
        var previousState:Object = storageManager.getGameState();
        if(previousState){
            grid = new Grid(previousState.grid.size, previousState.grid.cells);
            score = previousState.score;
            over = previousState.over;
            won = previousState.won;
            keepPlaying = previousState.keepPlaying;
        }else{
            grid = new Grid(size);
            score = 0;
            over = false;
            won = false;
            keepPlaying = false;
        }
        addStartTiles();
        actuate();
    }

    public function prepareTiles():void {
        grid.eachCell(
                function (x:int, y:int, tile:Tile):void {
                    if (tile) {
                        tile.mergedFrom = null;
                        tile.savePosition();
                    }
        });
    }

    public function moveTile(tile:Tile, cell:Cell):void {
        grid.cells[tile.x][tile.y] = null;
        grid.cells[cell.x][cell.y] = tile;
        tile.updatePosition(cell);
    }

    public function move(direction:int):void {
        var self:GameManager = this;
        if(isGameTerminated()){return}
        var cell:Cell, tile:Tile;

        var vector:Object     = getVector(direction);
        var traversals:Object = buildTraversals(vector);
        var moved:Boolean      = false;

        // Save the current tile positions and remove merger information
        prepareTiles();

        // Traverse the grid in the right direction and move tiles
        traversals.x.forEach(function (x:int):void {
            traversals.y.forEach(function (y:int):void {
                cell = { x: x, y: y };
                tile = self.grid.cellContent(cell);

                if (tile) {
                    var positions:Object = self.findFarthestPosition(cell, vector);
                    var next:Tile      = self.grid.cellContent(positions.next);

                    // Only one merger per row traversal?
                    if (next && next.value === tile.value && !next.mergedFrom) {
                        var merged = new Tile(positions.next, tile.value * 2);
                        merged.mergedFrom = [tile, next];

                        self.grid.insertTile(merged);
                        self.grid.removeTile(tile);

                        // Converge the two tiles' positions
                        tile.updatePosition(positions.next);

                        // Update the score
                        self.score += merged.value;

                        // The mighty 2048 tile
                        if (merged.value === 2048) self.won = true;
                    } else {
                        self.moveTile(tile, positions.farthest);
                    }

                    if (!self.positionsEqual(cell, tile)) {
                        moved = true; // The tile moved from its original cell!
                    }
                }
            });
        });

        if (moved) {
            addRandomTile();

            if (!movesAvailable()) {
                over = true; // Game over!
            }

            actuate();
        }

    }

    private function buildTraversals(vector:Object):Object {
        var traversals:Object = { x: [], y: [] };

        for (var pos = 0; pos < size; pos++) {
            traversals.x.push(pos);
            traversals.y.push(pos);
        }

        // Always traverse from the farthest cell in the chosen direction
        if (vector.x === 1) traversals.x = traversals.x.reverse();
        if (vector.y === 1) traversals.y = traversals.y.reverse();

        return traversals;
    }

    private function getVector(direction:int):Object {
        var map:Array = [
            { x: 0,  y: -1 }, // Up
            { x: 1,  y: 0 },  // Right
            { x: 0,  y: 1 },  // Down
            { x: -1, y: 0 }   // Left
        ];
        return map[direction];
    }


    private function addStartTiles():void {
        for (var i:int = 0; i < startTiles; i++) {
            addRandomTile();
        }
    }

    private function addRandomTile():void {
        if (grid.cellsAvailable()) {
            var value:int = Math.random() < 0.9 ? 2 : 4;
            var tile = new Tile(grid.randomAvailableCell(), value);
            grid.insertTile(tile);
        }
    }



    private function actuate():void {
        if (storageManager.getBestScore() < score) {
            storageManager.setBestScore(score);
        }

        // Clear the state when the game is over (game over only, not win)
        if (over) {
            storageManager.clearGameState();
        } else {
            storageManager.setGameState(serialize());
        }

        actuator.actuate(grid, {
            score:      score,
            over:       over,
            won:        won,
            bestScore:  storageManager.getBestScore(),
            terminated: isGameTerminated()
        });
    }

    private function isGameTerminated():Boolean {
        return over || (won && !keepPlaying);
    }

    /**
     * Represent the current game as an object
     * @return  the current game as an object
     */
    private function serialize():Object {
        return {
            grid:        grid.serialize(),
            score:       score,
            over:        over,
            won:         won,
            keepPlaying: keepPlaying
        };
    }


    public function findFarthestPosition(cell:Cell, vector:Object):Object {
        var previous:Cell;

        // Progress towards the vector direction until an obstacle is found
        do {
            previous = cell;
            cell = new Cell(previous.x + vector.x, previous.y + vector.y);
        } while (grid.withinBounds(cell) &&
                grid.cellAvailable(cell));

        return {
            farthest: previous,
            next: cell // Used to check if a merge is required
        };
    }
}
}
