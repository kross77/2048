/**
 * Created by Administator on 21.10.14.
 */
package core.managers.actuator.ui {
import core.object.Grid;
import core.object.Tile;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;

import org.bytearray.display.ScaleBitmap;

public class GridBitmapUI extends GridUI {
    [Embed(source="../../../../../../resources/standart-skin.png")]
    public static var Skin:Class;
    private var bg:ScaleBitmap;



    override protected function init():void {
        rect = new GridBitmapEmptyRectangleUI();
        bg = new ScaleBitmap(new Skin().bitmapData);
        addChild(bg);
    }

    override public function redraw(grid:Grid):void {

        _grid = grid;
        var width:int = this.width = borderWeight + (rect.width + borderWeight) * grid.size;
        var height:int = this.height = borderWeight + (rect.height + borderWeight) * grid.size;

        if (!fade) {
            createFade();
        }


        createBGBD();


        //draw empty rectangles
        for (var i:int = 0; i < _grid.size; i++) {
            for (var j:int = 0; j < _grid.size; j++) {
                rect.drawIn(emptyLayer.graphics, i, j, borderWeight);
            }
        }

    }

    private function createBGBD():void {
        var bd:BitmapData = new Skin().bitmapData;
        var bgBD:BitmapData = new BitmapData(rect.width, rect.height, true, 0x00ffffff);
        bgBD.draw(bd);
        bg.bitmapData.dispose();
        bg.bitmapData = bgBD;
        bg.width = width;
        bg.height = height;
        var scaleRect:Rectangle = new Rectangle(cornerRadius, cornerRadius, rect.width - 2 * cornerRadius, rect.height - 2 * cornerRadius);
        bg.scale9Grid = scaleRect;
    }

    private function getBgBitmapData():BitmapData {
        var skin:Bitmap = new Skin();
        var w:int = rect.width;
        var h:int = rect.height;
        var bmd:BitmapData = new BitmapData(w, h, true, 0x00ffffff);
        bmd.draw(skin.bitmapData);
        return bmd;
    }

    override protected function createFromTile(tile:Tile):ITileDisplayObject {
        var sprite:TileBitmapSprite = new TileBitmapSprite();
        sprite.draw(tile, jsonGridParams);
        return sprite;
    }
}
}
