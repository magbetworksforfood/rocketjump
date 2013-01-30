package view {
    import as3isolib.display.primitive.IsoBox;
    import as3isolib.graphics.SolidColorFill;

    import model.TileModel;

    public class TileView extends IsoBox {

        private var _model:TileModel;

        private var defaultFills:Array = [
            new SolidColorFill(0xAAAAAA, 1),
            new SolidColorFill(0x555555, 1),
            new SolidColorFill(0xAAAAAA, 1)
        ];

        private var selectedFills:Array = [
            new SolidColorFill(0xAA0000, 1),
            new SolidColorFill(0x550000, 1),
            new SolidColorFill(0xAA0000, 1)
        ];

        public function TileView(model:TileModel = null) {
            this.model = model;
        }

        public function get model():TileModel {
            return _model;
        }

        public function set model(value:TileModel):void {
            if (_model != value) {
                _model = value;

                update();
            }
        }


        override public function set height(value:Number):void {
            if (height != value) {
                super.height = value;

                //hack: negative height implementation
                z = value < 0 ? value : 0;
            }
        }

        public function update():void {
            if (_model) {
                width = _model.width;
                height = _model.height;
                length = _model.length;

                fills = _model.selected ? selectedFills : defaultFills;
            }
        }
    }
}
