package com.datami;

import com.datami.smi.SdState;
import com.datami.smi.SdStateChangeListener;
import com.datami.smi.SmiResult;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import android.util.Log;

/**
 * Created by damandeepsingh on 09/10/17.
 */

public class DatamiSDStateChangePlugin extends CordovaPlugin {
    private static CallbackContext connectionCallbackContext;


    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
    }

    public static void onChange() {
        String sdState = "";
        sdState = DatamiApplication.smiResult.getSdState().name();
        if (DatamiApplication.smiResult.getSdState() == SdState.SD_NOT_AVAILABLE) {
            sdState = sdState + ", Reason: "+DatamiApplication.smiResult.getSdReason().name();
        }
        if (connectionCallbackContext != null) {
            Log.d("TEST","SENDING RESULT");
            PluginResult result = new PluginResult(PluginResult.Status.OK, sdState);
            result.setKeepCallback(true);
            connectionCallbackContext.sendPluginResult(result);
        }
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        Log.d("TEST","TEST");
        if (action.equals("getSDState")) {
            Log.d("TEST","getSDState");
            this.connectionCallbackContext = callbackContext;

            String sdState = "";

            if (DatamiApplication.smiResult != null) {
                Log.d("TEST","mSmiResult");
                sdState = DatamiApplication.smiResult.getSdState().name();
                if (DatamiApplication.smiResult.getSdState() == SdState.SD_NOT_AVAILABLE) {
                    Log.d("TEST","SD NA");
                    sdState = sdState + ", Reason: "+DatamiApplication.smiResult.getSdReason().name();
                }
            }

            PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, sdState);
            pluginResult.setKeepCallback(true);
            callbackContext.sendPluginResult(pluginResult);
            return true;
        }
        return false;
    }
    
}
