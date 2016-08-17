function MyTarget() {
}

MyTarget.prototype.loadBanner = function(slotId, success, fail) {
    cordova.exec(success, fail, "MyTargetPlugin", "loadBanner", [slotId]);
}

MyTarget.prototype.showBanner = function(success, fail) {
    cordova.exec(success, fail, "MyTargetPlugin", "showBanner", []);
}

MyTarget.prototype.removeBanner = function(success, fail) {
    cordova.exec(success, fail, "MyTargetPlugin", "removeBanner", []);
}

MyTarget.prototype.loadFullscreen = function(slotId, success, fail) {
    cordova.exec(success, fail, "MyTargetPlugin", "loadFullscreen", [slotId]);
}

MyTarget.prototype.showFullscreen = function(success, fail) {
    cordova.exec(success, fail, "MyTargetPlugin", "showFullscreen", []);
}

module.exports = new MyTarget();
