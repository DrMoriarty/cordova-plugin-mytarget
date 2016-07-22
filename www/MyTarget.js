function MyTarget() {
}

MyTarget.prototype.makeBanner = function(slotId, success, fail) {
    cordova.exec(success, fail, "MyTargetPlugin", "makeBanner", [slotId]);
}

MyTarget.prototype.makeFullscreen = function(slotId, success, fail) {
    cordova.exec(success, fail, "MyTargetPlugin", "makeFullscreen", [slotId]);
}

module.exports = new MyTarget();
