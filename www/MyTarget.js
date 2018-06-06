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

MyTarget.prototype.setUserConsent = function(consent, success, fail) {
    cordova.exec(success, fail, "MyTargetPlugin", "setUserConsent", [consent]);
}

MyTarget.prototype.setUserAgeRestricted = function(ageRestricted, success, fail) {
    cordova.exec(success, fail, "MyTargetPlugin", "setUserAgeRestricted", [ageRestricted]);
}

module.exports = new MyTarget();
