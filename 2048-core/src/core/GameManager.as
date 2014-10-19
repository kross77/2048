/**
 * Created by Administator on 13.10.14.
 */
package core {
import core.managers.actuator.IActuator;
import core.managers.input.G2048InputManager;
import core.managers.storage.IStorageManager;
import core.object.Cell;
import core.object.Grid;
import core.object.IPositionObject;
import core.object.Tile;
import core.object.model.GameManagerVO;

import game.actions.GameAction;

public class GameManager {
    public var inputManager:G2048InputManager;
    public var storageManager:IStorageManager;
    public var actuator:IActuator;
    public var grid:Grid;

    private var _keepPlaying:Boolean;

    public var modelVO:GameManagerVO;

    public function GameManager(inputManager:G2048InputManager, storageManager:IStorageManager, actuator:IActuator) {
        this.inputManager = inputManager;
        this.storageManager = storageManager;
        this.actuator = actuator;
        storageManager.clearGameState();
        actuator.continueGame();
        inputManager.onActionCallback = inputManagerActionHandler;
        setup();
    }

    private function inputManagerActionHandler(type:String, params:Object = null):void {
        switch (type) {
            case GameAction.MOVE:
                move(params as int);
                break;
            case GameAction.KEEP_PLAYING:
                keepPlaying();
                break;
            case GameAction.RESTART:
                restart();
                break;
        }
    }


    /**
     * Restart the game
     */
    public function restart():void {
        storageManager.clearGameState();
        actuator.continueGame();
        setup();

    }

    /**
     * Keep playing after winning (allows going over 2048)
     */
    public function keepPlaying():void {
        _keepPlaying = true;
        this.actuator.continueGame(); // Clear the game won/lost message
    }

    /**
     *  Return true if the game is lost, or has won and the user hasn't kept playing
     */
    public function isGameTerminated():Boolean {
        return modelVO.over || (modelVO.won && !_keepPlaying);
    }

    /**
     * Set up the game
     */
    public function setup():void {
        var previousState:Object = storageManager.getGameState();
        if (previousState) {
            grid = new Grid(previousState.grid.size, previousState.grid.cells);
            modelVO.score = previousState.score;
            modelVO.over = previousState.over;
            modelVO.won = previousState.won;
            _keepPlaying = previousState.keepPlaying;
        } else {
            grid = new Grid(modelVO.size);
            modelVO.score = 0;
            modelVO.over = false;
            modelVO.won = false;
            _keepPlaying = false;
        }
        addStartTiles();
        actuate();
    }

    /**
     *  Set up the initial tiles to start the game with
     */
    public function addStartTiles():void {
        for (var i:int = 0; i < modelVO.startTiles; i++) {
            addRandomTile();
        }
    }

    /**
     * Adds a tile in a random position
     */
    private function addRandomTile():void {
        if (grid.cellsAvailable()) {
            var value:int = Math.random() < 0.9 ? 2 : 4;
            var tile:Tile = new Tile(grid.randomAvailableCell(), value);
            grid.insertTile(tile);
        }
    }

    /**
     * Sends the updated grid to the actuator
     */
    private function actuate():void {
        if (storageManager.getBestScore() < modelVO.score) {
            storageManager.setBestScore(modelVO.score);
        }

        // Clear the state when the game is modelVO.over (game modelVO.over only, not win)
        if (modelVO.over) {
            storageManager.clearGameState();
        } else {
            storageManager.setGameState(serialize());
        }

        actuator.actuate(grid, modelVO);
    }

    /**
     * Represent the current game as an object
     * @return  the current game as an object
     */
    private function serialize():Object {
        return {
            grid: grid.serialize(),
            score: modelVO.score,
            over: modelVO.over,
            won: modelVO.won,
            keepPlaying: keepPlaying
        };
    }

    /**
     * Save all tile positions and remove merger info
     */
    public function prepareTiles():void {
        grid.eachCell(
                function (x:int, y:int, tile:Tile):void {
                    if (tile) {
                        tile.mergedFrom = null;
                        tile.savePosition();
                    }
                });
    }

    /**
     * Move a tile and its representation
     * @param tile
     * @param cell
     */
    public function moveTile(tile:Tile, cell:Cell):void {
        grid.cells[tile.x][tile.y] = null;
        grid.cells[cell.x][cell.y] = tile;
        tile.updatePosition(cell);
    }

    /**
     * Move tiles on the grid in the specified direction
     * @param direction         specified direction
     */
    public function move(direction:int):void {
        var self:GameManager = this;
        if (isGameTerminated()) {
            return
        }
        var cell:Cell, tile:Tile;

        var vector:Object = getVector(direction);
        var traversals:Object = buildTraversals(vector);
        var moved:Boolean = false;

        // Save the current tile positions and remove merger information
        prepareTiles();

        // Traverse the grid in the right direction and move tiles
        traversals.x.forEach(function (x:int, ...rect):void {
            traversals.y.forEach(function (y:int, ...rect):void {
                cell = Cell.fromObject({ x: x, y: y });
                tile = self.grid.cellContent(cell);

                if (tile) {
                    var positions:Object = self.findFarthestPosition(cell, vector);
                    var next:Tile = self.grid.cellContent(positions.next);

                    // Only one merger per row traversal?
                    if (next && next.value === tile.value && !next.mergedFrom) {
                        var merged:Tile = new Tile(positions.next, tile.value * 2);
                        merged.mergedFrom = [tile, next];

                        self.grid.insertTile(merged);
                        self.grid.removeTile(tile);

                        // Converge the two tiles' positions
                        tile.updatePosition(positions.next);

                        // Update the score
                        self.modelVO.score += merged.value;

                        // The mighty 2048 tile
                        if (merged.value === 2048) self.modelVO.won = true;
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
                modelVO.over = true; // Game over!
            }

            actuate();
        }

    }

    /**
     * Get the vector representing the chosen direction
     * @param direction
     * @return
     */
    private function getVector(direction:int):Object {
        var map:Array = [
            { x: 0, y: -1 }, // Up
            { x: 1, y: 0 },  // Right
            { x: 0, y: 1 },  // Down
            { x: -1, y: 0 }   // Left
        ];
        return map[direction];
    }

    /**
     * Build a list of positions to traverse in the right order
     * @param vector
     * @return
     */
    private function buildTraversals(vector:Object):Object {
        var traversals:Object = { x: [], y: [] };

        for (var pos:int = 0; pos < modelVO.size; pos++) {
            traversals.x.push(pos);
            traversals.y.push(pos);
        }

        // Always traverse from the farthest cell in the chosen direction
        if (vector.x === 1) traversals.x = traversals.x.reverse();
        if (vector.y === 1) traversals.y = traversals.y.reverse();

        return traversals;
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

    public function movesAvailable():Boolean {
        return grid.cellsAvailable() || tileMatchesAvailable();
    }

    public function tileMatchesAvailable():Boolean {
        var self:GameManager = this;

        var tile:Tile;

        for (var x:int = 0; x < modelVO.size; x++) {
            for (var y:int = 0; y < modelVO.size; y++) {
                tile = grid.cellContent(Cell.fromObject({ x: x, y: y }));

                if (tile) {
                    for (var direction:int = 0; direction < 4; direction++) {
                        var vector:Object = self.getVector(direction);
                        var cell:Cell = Cell.fromObject({ x: x + vector.x, y: y + vector.y });

                        var other:Tile = self.grid.cellContent(cell);

                        if (other && other.value === tile.value) {
                            return true; // These two tiles can be merged
                        }
                    }
                }
            }
        }

        return false;
    }

    public function positionsEqual(first:IPositionObject, second:IPositionObject):Boolean {
        return first.x === second.x && first.y === second.y;
    }
}
}
