function MyTarget() {
}

MyTarget.prototype.makeBanner = function(slotId, success, fail) {
    cordova.exec(success, fail, "MyTargetPlugin", "makeBanner", [slotId]);
}

module.exports = new MyTarget();
