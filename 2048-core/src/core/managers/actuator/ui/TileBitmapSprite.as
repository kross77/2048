/**
 * Created by a.krasovsky on 17.11.2014.
 */
package core.managers.actuator.ui {
import com.greensock.TweenLite;
import com.greensock.easing.Ease;

import core.object.Tile;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Rectangle;

public class TileBitmapSprite extends Bitmap implements ITileDisplayObject {

    [Embed(source="../../../../../../resources/standart-skin.png")]
    public static var Skin:Class;
    private var gridExternalParams:Object;

    public function TileBitmapSprite() {

    }

    public function show(animationType:Ease = null, animationTime:Number = .3):void {
        this.width = this.height = 0;
        this.alpha = 0;
        this.x += cellParamWidth / 2;
        this.y += cellParamHeight / 2;
        TweenLite.to(this, animationTime, {
            alpha: 1,
            width: cellParamWidth,
            height: cellParamHeight,
            x: this.x - cellParamWidth / 2,
            y: this.y - cellParamHeight / 2,
            ease: animationType
        });
    }

    public function draw(tile:Tile, gridExternalParams:Object):void {
        this.gridExternalParams = gridExternalParams;
        if(bitmapData != null){
            bitmapData.dispose();
        }
//        var skin:Bitmap = new Skin();
        bitmapData = getBitmapDataTo(tile.value);

    }

    private function getBitmapDataTo(value:int):BitmapData {
        var skin:Bitmap = new Skin();
        var w:int = gridExternalParams.rect.width;
        var h:int = gridExternalParams.rect.height;
        var bmd:BitmapData = new BitmapData(w, h, true, 0x00ffffff);


        var sqrt:Number = logx(value, 2);
        var transX:Number = w + w * sqrt;
        var m:Matrix = new Matrix();
        m.translate(-transX, 0);
        bmd.draw(skin.bitmapData, m);
        return bmd;
    }

    function logx(val:Number, base:Number=10):Number {
        return Math.log(val)/Math.log(base)
    }

    private function get cellParamHeight():int {
        return gridExternalParams.rect.height;
    }

    private function get cellParamWidth():int {
        return gridExternalParams.rect.width;
    }
}
}
