package com.moepanda00.flutter_uni_scanner;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.ContentResolver;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Vibrator;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.widget.ImageView;

import java.io.FileNotFoundException;
import java.util.List;

import cn.bingoogolapple.qrcode.core.QRCodeView;
import cn.bingoogolapple.qrcode.zxing.ZXingView;
import pub.devrel.easypermissions.AfterPermissionGranted;
import pub.devrel.easypermissions.EasyPermissions;


public class QScanActivity extends Activity
        implements QRCodeView.Delegate,
        EasyPermissions.PermissionCallbacks {

    private static final String TAG = QScanActivity.class.getSimpleName();
    private static final int REQUEST_CODE_CHOOSE_QRCODE_FROM_GALLERY = 666;

    private ZXingView mZXingView;
    private boolean torchOn = false;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_test_scan);

        mZXingView = findViewById(R.id.zxingview);
        mZXingView.setDelegate(this);
        mZXingView.getScanBoxView().setOnlyDecodeScanBoxArea(true); // 仅识别扫描框中的码

        if(getIntent().getStringExtra(Constant.TIP_TEXT)!=null){
            mZXingView.getScanBoxView().setQRCodeTipText(getIntent().getStringExtra(Constant.TIP_TEXT));
        }
    }

    @Override
    protected void onStart() {
        super.onStart();
        requestCodeQRCodePermissions();
    }

    @Override
    protected void onStop() {
        mZXingView.stopCamera(); // 关闭摄像头预览，并且隐藏扫描框
        super.onStop();
    }

    @Override
    protected void onDestroy() {
        mZXingView.onDestroy(); // 销毁二维码扫描控件
        super.onDestroy();
    }

    @SuppressLint("MissingPermission")
    private void vibrate() {
        Vibrator vibrator = (Vibrator) getSystemService(VIBRATOR_SERVICE);
        vibrator.vibrate(200);
    }

    @Override
    public void onScanQRCodeSuccess(String result) {
        Log.i(TAG, "result:" + result);
        vibrate();
        finishActivity(true, result);
    }

    @Override
    public void onCameraAmbientBrightnessChanged(boolean isDark) {
        // 这里是通过修改提示文案来展示环境是否过暗的状态，接入方也可以根据 isDark 的值来实现其他交互效果
        String tipText = mZXingView.getScanBoxView().getTipText();
        String ambientBrightnessTip = "\n环境过暗，请打开闪光灯";
        if (isDark) {
            if (!tipText.contains(ambientBrightnessTip)) {
                mZXingView.getScanBoxView().setTipText(tipText + ambientBrightnessTip);
            }
        } else {
            if (tipText.contains(ambientBrightnessTip)) {
                tipText = tipText.substring(0, tipText.indexOf(ambientBrightnessTip));
                mZXingView.getScanBoxView().setTipText(tipText);
            }
        }
    }

    @Override
    public void onScanQRCodeOpenCameraError() {
        Log.e(TAG, "打开相机出错");
        finishActivity(false, "打开相机出错");
    }

    @SuppressLint("UseCompatLoadingForDrawables")
    public void onClick(View v) {
        if(v.getId()==R.id.iv_gallery){
            Intent intent = new Intent();
            intent.setAction(Intent.ACTION_GET_CONTENT);
            intent.setType("image/*");
            startActivityForResult(Intent.createChooser(intent, "选择图片"),REQUEST_CODE_CHOOSE_QRCODE_FROM_GALLERY);
            closeTorch();
        }
        if(v.getId()==R.id.iv_torch){
            triggerTorch();
        }
        if(v.getId()==R.id.iv_back){
            finishActivity(false, "CANCEL");
        }
    }

    void closeTorch(){
        this.torchOn = true;
        triggerTorch();
    }

    void triggerTorch(){
        ImageView imageView = findViewById(R.id.iv_torch);
        if(torchOn){
            imageView.setImageDrawable(getResources().getDrawable(R.mipmap.qrcode_scan_btn_flash_nor));
            mZXingView.closeFlashlight();
        }else{
            imageView.setImageDrawable(getResources().getDrawable(R.mipmap.qrcode_scan_btn_flash_sel));
            mZXingView.openFlashlight();
        }
        torchOn = !torchOn;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        mZXingView.startSpotAndShowRect(); // 显示扫描框，并开始识别

        if (resultCode == Activity.RESULT_OK && requestCode == REQUEST_CODE_CHOOSE_QRCODE_FROM_GALLERY) {
            data.getStringExtra("picturePath");
            Uri uri = data.getData();
            ContentResolver cr = getContentResolver();
            try {
                Bitmap bmp = BitmapFactory.decodeStream(cr.openInputStream(uri));
                mZXingView.decodeQRCode(bmp);
            } catch (FileNotFoundException e) {
                e.printStackTrace();
                finishActivity(false, e.getMessage());
            }
        }
    }


    private void finishActivity(boolean success, String result){
        Intent intent = new Intent();
        if(success){
            intent.putExtra("SCAN_RESULT", result);
            setResult(Activity.RESULT_OK, intent);
        }else{
            intent.putExtra("ERROR_CODE", result);
            setResult(Activity.RESULT_CANCELED, intent);
        }
        finish();
    }


    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        EasyPermissions.onRequestPermissionsResult(requestCode, permissions, grantResults, this);
    }

    @Override
    public void onPermissionsGranted(int requestCode, List<String> perms) {
        scan();
    }

    @Override
    public void onPermissionsDenied(int requestCode, List<String> perms) {
    }

    private static final int REQUEST_CODE_QRCODE_PERMISSIONS = 1;
    @AfterPermissionGranted(REQUEST_CODE_QRCODE_PERMISSIONS)
    private void requestCodeQRCodePermissions() {
        String[] perms = {Manifest.permission.CAMERA, Manifest.permission.READ_EXTERNAL_STORAGE};
        if (!EasyPermissions.hasPermissions(this, perms)) {
            EasyPermissions.requestPermissions(this, "扫码需要打开相机权限", REQUEST_CODE_QRCODE_PERMISSIONS, perms);
        }else{
            scan();
        }
    }

    private void scan(){
        mZXingView.startCamera(); // 打开后置摄像头开始预览，但是并未开始识别
//        mZXingView.startCamera(Camera.CameraInfo.CAMERA_FACING_FRONT); // 打开前置摄像头开始预览，但是并未开始识别
        mZXingView.startSpotAndShowRect(); // 显示扫描框，并开始识别
    }


    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if ((keyCode == KeyEvent.KEYCODE_BACK)) {
            finishActivity(false, "CANCEL");
            return false;
        }else {
            return super.onKeyDown(keyCode, event);
        }

    }
}