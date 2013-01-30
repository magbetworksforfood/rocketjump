package model {
    import flash.events.Event;
    import flash.events.EventDispatcher;

    import model.GlobalConfig;

    public class TileModel extends EventDispatcher {

        public var index:uint;
        private var _width:Number;
        private var _height:Number;
        private var _length:Number;
        private var _selected:Boolean;

        public function TileModel(index:uint) {
            this.index = index;
            init();
        }

        private function init():void {
            width = GlobalConfig.TILE_WIDTH;
            height = GlobalConfig.TILE_HEIGHT;
            length = GlobalConfig.TILE_LENGTH;

            _selected = false;
        }

        public function get height():Number {
            return _height;
        }

        public function set height(value:Number):void {
            if (_height != value) {
                _height = value;

                notifyChange();
            }
        }

        public function get width():Number {
            return _width;
        }

        public function set width(value:Number):void {
            if (_width != value) {
                _width = value;

                notifyChange();
            }
        }

        public function get length():Number {
            return _length;
        }

        public function set length(value:Number):void {
            if (_length != value) {
                _length = value;

                notifyChange();
            }
        }

        public function get selected():Boolean {
            return _selected;
        }

        public function set selected(value:Boolean):void {
            if (_selected != value) {
                _selected = value;

                notifyChange();
            }
        }

        private function notifyChange():void {
            dispatchEvent(new Event(Event.CHANGE));
        }
    }
}
