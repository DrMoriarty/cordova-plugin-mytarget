
var androidHelper = require('./lib/android-helper');
var utilities = require("./lib/utilities");

module.exports = function(context) {

    var platforms = context.opts.cordova.platforms;

    if (platforms.indexOf("android") !== -1) {
        androidHelper.removeFabricBuildToolsFromGradle();
        androidHelper.addFabricBuildToolsGradle();
    }
};
