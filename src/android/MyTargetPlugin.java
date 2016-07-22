package ru.orangeapps.mytarget;

import android.content.Context;
import android.util.Log;
import android.app.Activity;
import android.widget.RelativeLayout;
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
import com.my.target.ads.MyTargetVideoView;
import com.my.target.ads.InterstitialAd;

public class MyTargetPlugin extends CordovaPlugin {
    private static final String TAG = "MyTarget";
    private static final String ACTION_INIT = "initMyTarget";
    private static final String ACTION_MAKE_BANNER = "makeBanner";
    private static final String ACTION_MAKE_FULLSCREEN = "makeFullscreen";
    private ViewGroup layout = null;
    private CallbackContext _callbackContext;
    private MyTargetView bannerView = null;

    private Context getApplicationContext() {
        return this.getActivity().getApplicationContext();
    }

    private Activity getActivity() {
        return (Activity)this.webView.getContext();
    }

    private void success() {
        if(_callbackContext != null) {
            _callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
            _callbackContext.success();
        }
    }
    private void fail(String err) {
        if(err == null) err = "Error";
        if(_callbackContext != null) {
            _callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, err));
            _callbackContext.error(err);
        }
    }

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        CordovaActivity activity = (CordovaActivity)this.cordova.getActivity();
        layout = (ViewGroup)activity.getWindow().getDecorView().getRootView();
        Log.i(TAG, "1) Find root object with type "+layout.getClass().toString());
    }

    @Override
    protected void pluginInitialize() {
        CordovaActivity activity = (CordovaActivity)this.cordova.getActivity();
        layout = (ViewGroup)activity.getWindow().getDecorView().getRootView();
        Log.i(TAG, "2) Find root object with type "+layout.getClass().toString());
    }

    @Override
    public boolean execute(String action, CordovaArgs args, final CallbackContext callbackContext) throws JSONException {
        this._callbackContext = callbackContext;
        if(ACTION_INIT.equals(action)) {
            Log.i(TAG, "MyTarget initialize");
            return true;
        } else if(ACTION_MAKE_BANNER.equals(action)) {
            return makeBanner(args.getInt(0));
        } else if(ACTION_MAKE_FULLSCREEN.equals(action)) {
            return makeFullScreen(args.getInt(0));
        }
        Log.e(TAG, "Unknown action: "+action);
        fail("Unimplemented method: "+action);
        return true;
    }

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

    @Override
    public void onDestroy() {
        Log.i(TAG, "Destroy");
        if(bannerView != null) {
            bannerView.destroy();
            bannerView = null;
        }
    }

    private boolean makeBanner(final int slot) {
        if(bannerView != null) {
            Log.e(TAG, "Banner view already created");
            fail("Banner view already created");
        } else {
            getActivity().runOnUiThread(new Runnable() {
                    public void run() {
                        bannerView = new MyTargetView(getActivity());
                        bannerView.init(slot);

                        // Добавляем экземпляр в лэйаут главной активности
                        final ViewGroup.LayoutParams adViewLayoutParams = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                        //adViewLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
                        layout.post(new Runnable() {
                                public void run() {
                                    Log.i(TAG, "Make new banner with slot id: "+slot);
                                    layout.addView(bannerView, adViewLayoutParams);
                                }
                            });

                        // Устанавливаем слушатель событий
                        bannerView.setListener(new MyTargetView.MyTargetViewListener() {
                                @Override
                                public void onLoad(MyTargetView myTargetView) {
                                    // Данные успешно загружены, запускаем показ объявлений
                                    Log.i(TAG, "Banner has been loaded");
                                    myTargetView.start();
                                }

                                @Override
                                public void onNoAd(String reason, MyTargetView myTargetView) {
                                    Log.e(TAG, "No ads for banner");
                                }

                                @Override
                                public void onClick(MyTargetView myTargetView) {
                                    Log.i(TAG, "Banner clicked");
                                }
                            });

                        // Запускаем загрузку данных
                        bannerView.load();
                        success();
                    }
                });
        }
        return true;
    }

    private boolean makeFullScreen(final int slot) {
        getActivity().runOnUiThread(new Runnable() {
                public void run() {
                    InterstitialAd ad = new InterstitialAd(slot, getActivity());
                    ad.setListener(new InterstitialAd.InterstitialAdListener() {
                            @Override
                            public void onLoad(InterstitialAd ad) {
                                Log.i(TAG, "Fullscreen ad was loaded. Slot "+slot);
                                ad.show();
                            }

                            @Override
                            public void onNoAd(String reason, InterstitialAd ad) {
                                Log.e(TAG, "No available fullscreen ad for slot "+slot);
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
                    ad.load();
                    success();
                }
            });
        return true;
    }
};
