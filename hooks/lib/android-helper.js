
var fs = require("fs");
var path = require("path");
var utilities = require("./utilities");

module.exports = {

    addFabricBuildToolsGradle: function() {

        var buildGradle = utilities.readBuildGradle();

        buildGradle +=  [
            "",
            "// MyTarget Cordova Plugin - Start",
            "configurations.all {",
            "    resolutionStrategy.eachDependency { DependencyResolveDetails details ->",
            "        if (details.requested.group == 'com.google.android.exoplayer') {",
            "            println 'Updating version for: $details.requested.group:$details.requested.name:$details.requested.version --> 2.8.1'",
            "            details.useVersion '2.8.1'",
            "        }",
            "    }",
            "}",
            "// MyTarget Cordova Plugin - End",
        ].join("\n");

        utilities.writeBuildGradle(buildGradle);
    },

    removeFabricBuildToolsFromGradle: function() {

        var buildGradle = utilities.readBuildGradle();

        buildGradle = buildGradle.replace(/\n\/\/ MyTarget Cordova Plugin - Start[\s\S]*\/\/ MyTarget Cordova Plugin - End/, "");

        utilities.writeBuildGradle(buildGradle);
    }
};
