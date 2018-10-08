package ru.orangeapps.mytarget;

import android.content.Context;
import android.util.Log;
import android.app.Activity;
import android.widget.FrameLayout;
import android.view.ViewGroup;

import org.json.JSONException;
import org.json.JSONArray;
import org.json.JSONObject;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaArgs;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.apache.cordova.CordovaActivity;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;

import com.my.target.ads.MyTargetView;
import com.my.target.ads.InterstitialAd;
import com.my.target.common.MyTargetPrivacy;

public class MyTargetPlugin extends CordovaPlugin {
    private static final String TAG = "MyTarget";
    private static final String ACTION_INIT = "initMyTarget";
    private static final String ACTION_LOAD_BANNER = "loadBanner";
    private static final String ACTION_SHOW_BANNER = "showBanner";
    private static final String ACTION_REMOVE_BANNER = "removeBanner";
    private static final String ACTION_LOAD_FULLSCREEN = "loadFullscreen";
    private static final String ACTION_SHOW_FULLSCREEN = "showFullscreen";
    private static final String ACTION_SET_CONSENT = "setUserConsent";
    private static final String ACTION_SET_AGE_RESTRICTED = "setUserAgeRestricted";
    private FrameLayout layout = null;
    //private CallbackContext _callbackContext;
    private MyTargetView bannerView = null;
    private InterstitialAd fullscreenAd = null;

    private Context getApplicationContext() {
        return this.getActivity().getApplicationContext();
    }

    private Activity getActivity() {
        return (Activity)this.webView.getContext();
    }

    private void success(String result, CallbackContext callbackContext) {
        if(result == null) result = "Ok";
        if(callbackContext != null) {
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
            //callbackContext.success();
        }
    }
    private void fail(String err, CallbackContext callbackContext) {
        if(err == null) err = "Error";
        if(callbackContext != null) {
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, err));
            //callbackContext.error(err);
        }
    }

    /*
    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        CordovaActivity activity = (CordovaActivity)this.cordova.getActivity();
        layout = (RelativeLayout)activity.getWindow().getDecorView().getRootView();
        Log.i(TAG, "1) Find root object with type "+layout.getClass().toString()+" child of "+layout.getClass().getSuperClass().toString());
    }
    */

    @Override
    protected void pluginInitialize() {
        CordovaActivity activity = (CordovaActivity)this.cordova.getActivity();
        layout = (FrameLayout)activity.getWindow().getDecorView().getRootView();
        /*
        if(layout instanceof AbsoluteLayout) Log.i(TAG, "AbsoluteLayout!!!");
        if(layout instanceof DrawerLayout) Log.i(TAG, "DrawerLayout!!!");
        if(layout instanceof FrameLayout) Log.i(TAG, "FrameLayout!!!");
        if(layout instanceof GridLayout) Log.i(TAG, "GridLayout!!!");
        if(layout instanceof LinearLayout) Log.i(TAG, "LinearLayout!!!");
        if(layout instanceof RelativeLayout) Log.i(TAG, "RelativeLayout!!!");
        if(layout instanceof SlidingPaneLayout) Log.i(TAG, "SlidingPaneLayout!!!");
        */
        Log.i(TAG, "Find root object with type "+layout.getClass().toString());
    }

    @Override
    public boolean execute(String action, CordovaArgs args, final CallbackContext callbackContext) throws JSONException {
        //this._callbackContext = callbackContext;
        if(ACTION_INIT.equals(action)) {
            Log.i(TAG, "MyTarget initialize");
            return true;
        } else if(ACTION_LOAD_BANNER.equals(action)) {
            return loadBanner(args.getInt(0), callbackContext);
        } else if(ACTION_SHOW_BANNER.equals(action)) {
            return showBanner(callbackContext);
        } else if(ACTION_REMOVE_BANNER.equals(action)) {
            return removeBanner(callbackContext);
        } else if(ACTION_LOAD_FULLSCREEN.equals(action)) {
            return loadFullScreen(args.getInt(0), callbackContext);
        } else if(ACTION_SHOW_FULLSCREEN.equals(action)) {
            return showFullScreen(callbackContext);
        } else if(ACTION_SET_CONSENT.equals(action)) {
            return setConsent(args.getBoolean(0), callbackContext);
        } else if(ACTION_SET_AGE_RESTRICTED.equals(action)) {
            return setAgeRestricted(args.getBoolean(0), callbackContext);
        }
        Log.e(TAG, "Unknown action: "+action);
        fail("Unimplemented method: "+action, callbackContext);
        return true;
    }

    /*
    @Override
    public void onPause(boolean multitasking) {
        Log.i(TAG, "Paused");
        if(bannerView != null) bannerView.pause();
    }

    @Override
    public void onResume(boolean multitasking) {
        Log.i(TAG, "Resume");
        if(bannerView != null) bannerView.resume();
    }

    @Override
    public void onStop() {
        Log.i(TAG, "Stop");
    }
    */

    @Override
    public void onDestroy() {
        Log.i(TAG, "Destroy");
        if(bannerView != null) {
            bannerView.destroy();
            bannerView = null;
        }
    }

    private boolean loadBanner(final int slot, final CallbackContext callbackContext) {
        if(bannerView != null) {
            Log.e(TAG, "Banner view already created");
            fail("Banner view already created", callbackContext);
        } else {
            getActivity().runOnUiThread(new Runnable() {
                    public void run() {
                        bannerView = new MyTargetView(getActivity());
                        bannerView.init(slot);

                        // Устанавливаем слушатель событий
                        bannerView.setListener(new MyTargetView.MyTargetViewListener() {
                                @Override
                                public void onLoad(MyTargetView myTargetView) {
                                    // Данные успешно загружены, запускаем показ объявлений
                                    Log.i(TAG, "Banner has been loaded");
                                    success("Banner loaded", callbackContext);
                                }

                                @Override
                                public void onNoAd(String reason, MyTargetView myTargetView) {
                                    Log.e(TAG, "No ads for banner");
                                    fail("No ads for banner "+slot, callbackContext);
                                }

                                @Override
                                public void onClick(MyTargetView myTargetView) {
                                    Log.i(TAG, "Banner clicked");
                                }
                            });

                        // Запускаем загрузку данных
                        bannerView.load();
                    }
                });
        }
        return true;
    }

    private boolean showBanner(final CallbackContext callbackContext) {
        if(bannerView == null) {
            Log.e(TAG, "Have no banner to show");
            fail("You should load banner before call showBanner", callbackContext);
        } else {
            // Устанавливаем слушатель событий
            bannerView.setListener(new MyTargetView.MyTargetViewListener() {
                    @Override
                    public void onLoad(MyTargetView myTargetView) {
                        Log.e(TAG, "Banner has been loaded twice");
                    }
                    @Override
                    public void onNoAd(String reason, MyTargetView myTargetView) {
                        Log.e(TAG, "No ads for loaded banner!");
                        fail("No ads for loaded banner ", callbackContext);
                    }
                    @Override
                    public void onClick(MyTargetView myTargetView) {
                        Log.i(TAG, "Banner clicked");
                        success("Banner clicked", callbackContext);
                    }
                });
            // Добавляем экземпляр в лэйаут главной активности
            final FrameLayout.LayoutParams adViewLayoutParams = new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT, 0x50);
            layout.post(new Runnable() {
                    public void run() {
                        Log.i(TAG, "Show new banner");
                        layout.addView(bannerView, adViewLayoutParams);
                        //bannerView.start();
                    }
                });

        }
        return true;
    }

    private boolean removeBanner(final CallbackContext callbackContext) {
        if(bannerView != null) {
            getActivity().runOnUiThread(new Runnable() {
                    public void run() {
                        layout.removeView(bannerView);
                        bannerView.destroy();
                        bannerView = null;
                        success(null, callbackContext);
                    }
                });
        } else {
            fail("No banner view", callbackContext);
        }
        return true;
    }

    private boolean loadFullScreen(final int slot, final CallbackContext callbackContext) {
        getActivity().runOnUiThread(new Runnable() {
                public void run() {
                    fullscreenAd = new InterstitialAd(slot, getActivity());
                    fullscreenAd.setListener(new InterstitialAd.InterstitialAdListener() {
                            @Override
                            public void onLoad(InterstitialAd ad) {
                                Log.i(TAG, "Fullscreen ad was loaded. Slot "+slot);
                                success("Fullscreen loaded", callbackContext);
                            }

                            @Override
                            public void onNoAd(String reason, InterstitialAd ad) {
                                Log.e(TAG, "No available fullscreen ad for slot "+slot);
                                fail("No ads for slot "+slot, callbackContext);
                            }

                            @Override
                            public void onClick(InterstitialAd ad) {
                                Log.i(TAG, "Click on fullscreen ad. Slot "+slot);
                            }

                            @Override
                            public void onDisplay(InterstitialAd ad) {
                                Log.i(TAG, "Display fullscreen ad. Slot "+slot);
                            }

                            @Override
                            public void onDismiss(InterstitialAd ad) {
                                Log.i(TAG, "Fullscreen ad dismiss. Slot "+slot);
                            }

                            @Override
                            public void onVideoCompleted(InterstitialAd ad) {
                                Log.i(TAG, "Fullscreen video completed. Slot "+slot);
                            }
                        });

                    // Запускаем загрузку данных
                    fullscreenAd.load();
                }
            });
        return true;
    }

    private boolean showFullScreen(final CallbackContext callbackContext) {
        if(fullscreenAd == null) {
            fail("You should call loadFullScreen before showFullScreen", callbackContext);
            Log.e(TAG, "Have no fullscreenAd to show");
        } else {
            fullscreenAd.setListener(new InterstitialAd.InterstitialAdListener() {
                    @Override
                    public void onLoad(InterstitialAd ad) {
                        Log.e(TAG, "Fullscreen ad was loaded twice.");
                    }

                    @Override
                    public void onNoAd(String reason, InterstitialAd ad) {
                        Log.e(TAG, "No available ad for loaded fullscreen Ad");
                        fail("No ads for loaded fullscreen Ad ", callbackContext);
                    }

                    @Override
                    public void onClick(InterstitialAd ad) {
                        Log.i(TAG, "Click on fullscreen ad");
                    }

                    @Override
                    public void onDisplay(InterstitialAd ad) {
                        Log.i(TAG, "Display fullscreen ad");
                    }

                    @Override
                    public void onDismiss(InterstitialAd ad) {
                        Log.i(TAG, "Fullscreen ad dismiss");
                        success("Fullscreen ad closed", callbackContext);
                    }

                    @Override
                    public void onVideoCompleted(InterstitialAd ad) {
                        Log.i(TAG, "Fullscreen video completed");
                    }
                });
            fullscreenAd.show();
        }
        return true;
    }

    private boolean setConsent(final boolean consent, final CallbackContext callbackContext) {
        MyTargetPrivacy.setUserConsent(consent);
        success("Ok", callbackContext);
        return true;
    }

    private boolean setAgeRestricted(final boolean ageRestricted, final CallbackContext callbackContext) {
        MyTargetPrivacy.setUserAgeRestricted(ageRestricted);
        success("Ok", callbackContext);
        return true;
    }
};
