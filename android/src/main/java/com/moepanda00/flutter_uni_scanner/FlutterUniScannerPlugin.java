package com.moepanda00.flutter_uni_scanner;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import java.util.HashMap;
import java.util.Map;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterUniScannerPlugin */
public class FlutterUniScannerPlugin implements
        FlutterPlugin,
        ActivityAware,
        MethodCallHandler,
        PluginRegistry.ActivityResultListener {


  private MethodChannel channel;
  Result result;
  private Context applicationContext;
  private Activity activity;

  /** FlutterUniScannerPlugin registerWith */
  //旧版的注册方式
  public static void registerWith(Registrar registrar) {
    FlutterUniScannerPlugin plugin = new FlutterUniScannerPlugin();
    registrar.addActivityResultListener(plugin);
    plugin.onAttachedToEngine(registrar.context(), registrar.messenger(), registrar.activity());
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    onAttachedToEngine(binding.getApplicationContext(), binding.getBinaryMessenger());
  }

  private void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger, Activity activity){
    this.activity = activity;
    onAttachedToEngine(applicationContext, messenger);
  }

  private void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
    this.applicationContext = applicationContext;
    channel = new MethodChannel(messenger, Constant.PLUGIN_NAME);
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    this.result = result;
    if (call.method.equals("startScan")) {
      Intent intent = new Intent(activity, QScanActivity.class);
      intent.putExtra(Constant.TIP_TEXT,(String)call.argument(Constant.TIP_TEXT));
      activity.startActivityForResult(intent, 100);
    }else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    if (requestCode == 100) {
      String errorCode = "0000";
      Map<String, String> map = new HashMap<>();
      map.put("errorCode",errorCode);
      if (resultCode == Activity.RESULT_OK) {
        String barcode = data.getStringExtra("SCAN_RESULT");
        map.put("code",barcode);
        result.success(map);
      } else {
        map.put("errorCode",data.getStringExtra("ERROR_CODE"));
        result.success(map);
      }
      return true;
    }
    return false;
  }


  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
    binding.addActivityResultListener(this);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromActivity() {

  }

}
