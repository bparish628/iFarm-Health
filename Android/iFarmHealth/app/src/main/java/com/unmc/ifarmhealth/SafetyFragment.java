package com.unmc.ifarmhealth;

import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.webkit.WebSettings;
import android.widget.Button;
import android.widget.LinearLayout;

public class SafetyFragment extends Fragment {

    public WebView webView;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View v=inflater.inflate(R.layout.safety_fragment, container, false);
        webView = (WebView) v.findViewById(R.id.webViewS);
        webView.setVisibility(View.GONE);

        WebSettings webSettings = webView.getSettings();
        webSettings.setJavaScriptEnabled(true);

        webView.setWebViewClient(new WebViewClient());

        return v;
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        final LinearLayout btnList = (LinearLayout)getView().findViewById(R.id.button_list);

        Button btn_cdc = (Button)getView().findViewById(R.id.button_cdc);
        Button btn_unmc = (Button)getView().findViewById(R.id.button_unmc);
        Button btn_eaoh = (Button)getView().findViewById(R.id.button_eaoh);

        btn_cdc.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v) {
                btnList.setVisibility(View.GONE);
                webView.setVisibility(View.VISIBLE);
                webView.loadUrl("https://www.cdc.gov/niosh/index.htm");
            }
        });

        btn_unmc.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v) {
                btnList.setVisibility(View.GONE);
                webView.setVisibility(View.VISIBLE);
                webView.loadUrl("https://www.unmc.edu/publichealth/cscash/");
            }
        });

        btn_eaoh.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v) {
                btnList.setVisibility(View.GONE);
                webView.setVisibility(View.VISIBLE);
                webView.loadUrl("https://www.unmc.edu/publichealth/departments/enviromental/index.html");
            }
        });
    }
}
