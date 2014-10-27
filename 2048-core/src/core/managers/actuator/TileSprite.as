/**
 * Created by a.krasovsky on 27.10.2014.
 */
package core.managers.actuator {
import com.greensock.TweenLite;

import core.object.Tile;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

public class TileSprite extends Sprite {
    private var gridExternalParams:Object;

    public function TileSprite() {
    }


    public function draw(tile:Tile, gridExternalParams:Object):void {
        this.gridExternalParams = gridExternalParams;
        graphics.beginFill(getBackgroundColorForTile(tile));
        graphics.drawRoundRect(0, 0, gridExternalParams.rect.width, gridExternalParams.rect.width, gridExternalParams.rect.cornerRadius);
        var txt:TextField = new TextField();
        txt.text = String(tile.value);
        addChild(txt);
        txt.setTextFormat(getTextFieldFormat());
        txt.autoSize = TextFieldAutoSize.CENTER;
        txt.x = (gridExternalParams.rect.width - txt.textWidth) / 2;
        txt.y = (gridExternalParams.rect.width - txt.textHeight) / 2;
        txt.textColor = getTextColorForTile(tile);
        cacheAsBitmap = true;
    }


    public function show():void {
        this.width = this.height = 0;
        this.alpha = 0;
        this.x += cellParamWidth / 2;
        this.y += cellParamHeight / 2;
        TweenLite.to(this, .3, {
            alpha: 1,
            width: cellParamWidth,
            height: cellParamHeight,
            x: x-cellParamWidth/2,
            y: y-cellParamHeight/2
        });
    }

    private function get cellParamHeight():int {
        return gridExternalParams.rect.height;
    }

    private function get cellParamWidth():int {
        return gridExternalParams.rect.width;
    }

    private function getTextFieldFormat():TextFormat {
        var tf:TextFormat = new TextFormat("Arial", 20);
        return tf;
    }

    private function getBackgroundColorForTile(tile:Tile):uint {
        var cellsParam:Object = gridExternalParams.cells;
        return cellsParam[String(tile.value)].background;
    }

    private function getTextColorForTile(tile:Tile):uint {
        var cellsParam:Object = gridExternalParams.cells;
        return cellsParam[String(tile.value)].color;
    }
}
}
