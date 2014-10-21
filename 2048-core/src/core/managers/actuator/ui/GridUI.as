/**
 * Created by Administator on 21.10.14.
 */
package core.managers.actuator.ui {
import core.object.Grid;

import mx.core.UIComponent;

public class GridUI extends UIComponent {
    public var background:uint;
    public var cornerRadius:int;
    public var borderWeight:int
    public var rect:GridEmptyRectangleUI = new GridEmptyRectangleUI();
    private var _grid:Grid;

    public function GridUI() {

    }

    public function setParamsFromObject(params:Object):void {
        for (var propertyName:String in params) {
            if (propertyName != "rect") {
                if (this.hasOwnProperty(propertyName)) {
                    this[propertyName] = params[propertyName];
                }
            } else {
                setEmptyRectangleParams(params[propertyName]);
            }

        }
    }

    private function setEmptyRectangleParams(params:Object):void {
        for (var propertyName:String in params) {
            if (rect.hasOwnProperty(propertyName)) {
                rect[propertyName] = params[propertyName];
            }

        }
    }

    public function redraw(grid:Grid):void {
        _grid = grid;
        graphics.clear();

        //draw background rectangle
        graphics.beginFill(background);
        graphics.drawRoundRect(0, 0, borderWeight + (rect.width + borderWeight) * grid.size, borderWeight + (rect.height + borderWeight) * grid.size, cornerRadius, cornerRadius);
        //draw empty rectangles
        for (var i:int = 0; i < _grid.size; i++) {
            for (var j:int = 0; j < _grid.size; j++) {
                rect.drawIn(graphics, i, j, borderWeight);
            }
        }

    }
}
}
