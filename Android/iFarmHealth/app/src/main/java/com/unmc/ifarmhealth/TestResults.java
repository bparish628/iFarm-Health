package com.unmc.ifarmhealth;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class TestResults extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.test_results);

        Bundle bundle = getIntent().getExtras();
        float score = bundle.getFloat("score");

        TextView displayScore = (TextView) findViewById(R.id.scoreDisplay);

        TextView displayDescription = (TextView) findViewById(R.id.description);

        if(score < 0.4){
            displayScore.setText("A");
            displayDescription.setText("Perfect!");
        } else if(0.4 < score && score < 0.7){
            displayScore.setText("B");
            displayDescription.setText("Good");
        } else if(0.7 < score && score < 1.2){
            displayScore.setText("C");
            displayDescription.setText("Below Average");
        } else if(1.2 < score && score < 2.0){
            displayScore.setText("D");
            displayDescription.setText("Poor");
        } else {
            displayScore.setText("F");
            displayDescription.setText("Get Some Rest");
        }

        writeToExternal();

        final File myFile = new File(getExternalFilesDir(null), "iFarmCSV.csv");
        /*if(myFile.exists()){
            StringBuilder text = new StringBuilder();
            try {
                BufferedReader br = new BufferedReader(new FileReader(myFile));
                String line;

                while ((line = br.readLine()) != null) {
                    text.append(line);
                    text.append('\n');
                }
                br.close();
            } catch (IOException e) {}
            displayScore.setText(text);
        }*/

        Button home_btn = (Button) findViewById(R.id.return_button);
        home_btn.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v) {
                myFile.delete();
                Intent intent = new Intent(v.getContext(), MainActivity.class);
                startActivity(intent);
            }
        });

        final String filePath = myFile.getPath();

        Button export_btn = (Button) findViewById(R.id.export_button);
        export_btn.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v) {
                Intent sendIntent = new Intent();
                sendIntent.setAction(Intent.ACTION_SEND);
                sendIntent.setType("text/plain");
                sendIntent.putExtra(Intent.EXTRA_STREAM, Uri.parse("file:///"+filePath));
                startActivity(Intent.createChooser(sendIntent, "Share"));
            }
        });
    }

    public void writeToExternal(){
        try{
            File externalFile = new File(getExternalFilesDir(null), "iFarmCSV.csv");
            InputStream is = new FileInputStream(getFilesDir() + File.separator + "iFarmCSV.csv");
            OutputStream os = new FileOutputStream(externalFile);
            byte[] toWrite = new byte[is.available()];
            int result = is.read(toWrite);
            os.write(toWrite);
            is.close();
            os.close();
        } catch(Exception e) {}
    }
}
