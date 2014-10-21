/**
 * Created by Administator on 14.10.14.
 */
package core.object {
import core.object.Cell;
import core.object.IPositionObject;
import core.object.Tile;

public class Grid {
    private var _cells:Array;
    private var _size:int;
    public function Grid(size:int, previousState:Object = null) {
        _size = size;
        _cells = previousState ? fromState(previousState) : empty();
    }

    private function empty():Array {
        var cells:Array = [];
        for (var x:int = 0; x < _size; x++) {
            var row:Array = [];

            for (var y:int = 0; y < _size; y++) {
                row.push(null);
            }
            cells[x] = row;
        }
        return cells;
    }

    private function fromState(state:Object):Array {
        var cells:Array = [];

        for (var x:int = 0; x < _size; x++) {
            var row:Array = cells[x] = [];

            for (var y:int = 0; y < _size; y++) {
                var tile:Tile = state[x][y];
                row.push(tile ? new Tile(tile.position, tile.value) : null);
            }
        }
        return cells;
    }



    /**
     * Find the first available random position
     * @return
     */
    public function randomAvailableCell():Cell {
        var cells:Array = availableCells();

        if (cells.length) {
            return Cell.fromObject(cells[ Math.floor(Math.random() * cells.length)]);
        }
        return null;
    }

    /**
     * @return     available cells
     */
    private function availableCells():Array {
        var cells:Array = [];

        eachCell(function (x:int, y:int, tile:Tile):void {
            if (!tile) {
                cells.push({ x: x, y: y });
            }
        });

        return cells;
    }

    /**
     * Call callback for every cell
     */
    public function eachCell(callBack:Function):void {
        for (var x:int = 0; x < _size; x++) {
            for (var y:int = 0; y < _size; y++) {
                callBack(x, y, _cells[x][y]);
            }
        }
    }

    /**
     * Check if there are any cells available
     * @return boolean of any cells available
     */
    public function cellsAvailable():Boolean {
        return !!availableCells().length;
    }

    /**
     * Check if the specified cell is taken
     * @param cell
     * @return
     */
    public function cellAvailable(cell:Cell):Boolean {
        return !this.cellOccupied(cell);
    }

    public function cellOccupied(cell:Cell):Boolean {
        return !!this.cellContent(cell);
    }

    public function cellContent(cell:Cell):Tile {
        if (this.withinBounds(cell)) {
            return _cells[cell.x][cell.y];
        } else {
            return null;
        }
    }

    /**
     * Inserts a tile at its position
     * @param tile
     */
    public function insertTile(tile:Tile):void {
        _cells[tile.x][tile.y] = tile;
    }

    public function removeTile(tile:Tile):void {
        _cells[tile.x][tile.y] = null;
    }

    public function withinBounds(position:IPositionObject):Boolean {
        return position.x >= 0 && position.x < _size &&
                position.y >= 0 && position.y < _size;
    }


    public function serialize():Object {
        var cellState:Array = [];

        for (var x:int = 0; x < _size; x++) {
            var row:Array = [];

            for (var y:int = 0; y < _size; y++) {
                row.push(_cells[x][y] ? _cells[x][y].serialize() : null);
            }
            cellState[x] = row;
        }

        return {
            size: _size,
            cells: cellState
        };
    }

    public function get cells():Array {
        return _cells;
    }

    public function get size():int {
        return _size;
    }
}
}
