cordova-plugin-mytarget
=================

[MyTarget](https://target.my.com/partners/help/sdk/) integration for cordova

Installation

    cordova plugin add https://github.com/DrMoriarty/cordova-plugin-mytarget

or

    cordova plugin add cordova-plugin-mytarget

Usage:

    MyTarget.makeBanner(SLOT_ID, function(success){}, function(error){});
    
    MyTarget.makeFullscreen(SLOT_ID, function(success){}, function(error){});
    
you also can remove banner later:

    MyTarget.removeBanner(function(success) {}, function(error){});

For testing your can use these slot ids:

    SLOT_STANDARD_BANNER = 14170
    SLOT_INSTREAM = 9525
    SLOT_PROMO_AD = 6896
    SLOT_IMAGE_AD = 6481
    SLOT_PROMO_VIDEO_AD = 10138
    CONTENT_STREAM = 6590
    NATIVE_VIDEO = 30150
