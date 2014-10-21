/**
 * Created by Administator on 21.10.14.
 */
package core.managers.actuator {
import core.managers.actuator.ui.GridUI;
import core.object.Grid;
import core.object.model.GameManagerVO;

import flash.utils.ByteArray;

import mx.core.UIComponent;

public class JSONActuator extends UIComponent implements IActuator{
    [Embed(source="data/config.json",mimeType="application/octet-stream")]
    private var ConfigJsonFile:Class;
    private var gridUI:GridUI = new GridUI();

    public function JSONActuator() {
        var bytes:ByteArray = new ConfigJsonFile();
        var json:String = bytes.readUTFBytes(bytes.length);
        trace(json);
        var params:Object = JSON.parse(json);
        gridUI.setParamsFromObject(params.grid);
        addChild(gridUI);



    }

    public function continueGame():void {
    }

    public function actuate(params:GameManagerVO):void {
        gridUI.redraw(params.grid);
    }
}
}
