package com.unmc.ifarmhealth;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.os.SystemClock;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import java.io.File;
import java.io.FileOutputStream;
import java.util.LinkedList;

import com.jjoe64.graphview.GraphView;
import com.jjoe64.graphview.Viewport;
import com.jjoe64.graphview.series.DataPoint;
import com.jjoe64.graphview.series.LineGraphSeries;

public class BalanceTest extends Activity implements SensorEventListener {
    private LinkedList<dataPoint> dataPoints = new LinkedList<dataPoint>();
    private LinkedList<Float> deltaAvs = new LinkedList<Float>();
    private dataPoint tempPoint = new dataPoint();
    private boolean mInitialized = false, updating = true;
    private SensorManager mSensorManager;
    private Sensor mAccelerometer;
    private float mLastX = (float) 0.0, mLastY = (float) 0.0, mLastZ = (float) 0.0;

    private LineGraphSeries<DataPoint> seriesX;
    private LineGraphSeries<DataPoint> seriesY;
    private LineGraphSeries<DataPoint> seriesZ;
    private int lastX = 0;
    private int exerciseNum = 0;
    public long lastTimeCounter = 0;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_balance_test);

        mSensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        mAccelerometer = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        mSensorManager.registerListener(this, mAccelerometer, SensorManager.SENSOR_DELAY_NORMAL);
        lastTimeCounter = SystemClock.elapsedRealtime();

        // Get graph view instance
        GraphView graph = (GraphView) findViewById(R.id.graph);

        // Create x, y, and z data lines
        seriesX = new LineGraphSeries<DataPoint>();
        seriesX.setColor(Color.RED);
        graph.addSeries(seriesX);
        seriesY = new LineGraphSeries<DataPoint>();
        seriesY.setColor(Color.BLUE);
        graph.addSeries(seriesY);
        seriesZ = new LineGraphSeries<DataPoint>();
        seriesZ.setColor(Color.GREEN);
        graph.addSeries(seriesZ);

        // Customize graph settings
        Viewport viewport = graph.getViewport();
        viewport.setYAxisBoundsManual(true);
        viewport.setMinY(-10);
        viewport.setMaxY(10);
        viewport.setXAxisBoundsManual(true);
        viewport.setMinX(0);
        viewport.setMaxX(29);
    }

    @Override
    public void onResume() {
        super.onResume();

        mSensorManager.registerListener(this, mAccelerometer, SensorManager.SENSOR_DELAY_NORMAL);
    }

    @Override
    protected void onPause() {
        super.onPause();
        mSensorManager.unregisterListener(this);
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
    // Can be safely ignored for this project
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        if(updating) {
            ImageView iv = (ImageView) findViewById(R.id.image);
            TextView countdown = (TextView) findViewById(R.id.countdown);
            iv.setVisibility(View.VISIBLE);

            // Starting countdown
            if (exerciseNum == 0) {
                countdown.setVisibility(View.VISIBLE);
                iv.setImageResource(R.drawable.arms_out);
                if (SystemClock.elapsedRealtime() - lastTimeCounter < 1000) {
                    countdown.setText("5");
                } else if (SystemClock.elapsedRealtime() - lastTimeCounter < 2000) {
                    countdown.setText("4");
                } else if (SystemClock.elapsedRealtime() - lastTimeCounter < 3000) {
                    countdown.setText("3");
                } else if (SystemClock.elapsedRealtime() - lastTimeCounter < 4000) {
                    countdown.setText("2");
                } else if (SystemClock.elapsedRealtime() - lastTimeCounter < 5000) {
                    countdown.setText("1");
                } else if (SystemClock.elapsedRealtime() - lastTimeCounter > 5000) {
                    lastTimeCounter = SystemClock.elapsedRealtime();
                    exerciseNum = 1;
                }
            } else {
                countdown.setVisibility(View.INVISIBLE);
            }

            // Give the user a picture of what they should be doing
            if (SystemClock.elapsedRealtime() - lastTimeCounter < 10000 && exerciseNum == 1) {
                iv.setImageResource(R.drawable.arms_out);
            } else if (SystemClock.elapsedRealtime() - lastTimeCounter > 10000 && exerciseNum == 1) {
                exerciseNum = 2;
                iv.setImageResource(R.drawable.left_leg);
                lastTimeCounter = SystemClock.elapsedRealtime();
            } else if (SystemClock.elapsedRealtime() - lastTimeCounter > 10000 && exerciseNum == 2) {
                exerciseNum = 3;
                iv.setImageResource(R.drawable.right_leg);
                lastTimeCounter = SystemClock.elapsedRealtime();
            } else if (SystemClock.elapsedRealtime() - lastTimeCounter > 10000 && exerciseNum == 3) {
                makeFile();

                Intent mintent = new Intent(this, TestResults.class);
                mintent.putExtra("score", calculateScore());
                startActivity(mintent);
            }

            if (exerciseNum != 0) {
                float x = event.values[0];
                float y = event.values[1];
                float z = event.values[2];

                /*x = (float)Math.round(x * 100000d) / 100000d;
                y = (float)Math.round(y * 100000d) / 100000d;
                z = (float)Math.round(z * 100000d) / 100000d;*/

                // Save data points for csv file
                tempPoint.setxData(x);
                tempPoint.setyData(y);
                tempPoint.setzData(z);
                dataPoints.add(tempPoint);

                // Graph data point
                addEntry(x, y - 10, z);

                if (!mInitialized) { // If this is the first data point,
                    mLastX = x;      // don't get deltas
                    mLastY = y;
                    mLastZ = z;
                    mInitialized = true;
                } else {            // Compute deltas
                    float deltaX = (float) Math.abs(mLastX - x);
                    float deltaY = (float) Math.abs(mLastY - y);
                    float deltaZ = (float) Math.abs(mLastZ - z);
                    float deltaAv = (deltaX + deltaY + deltaZ) / 3;
                    // Save delta data point
                    deltaAvs.add(deltaAv);

                    // Set last variables to current variables
                    mLastX = x;
                    mLastY = y;
                    mLastZ = z;
                }
            }
        }
    }

    // Add data point to graph
    private void addEntry(float xData, float yData, float zData) {
        // Display max 30 points on the viewport and scroll to end
        seriesX.appendData(new DataPoint(lastX, xData), true, 30);
        seriesY.appendData(new DataPoint(lastX, yData), true, 30);
        seriesZ.appendData(new DataPoint(lastX, zData), true, 30);
        lastX++; // Update graph's x axis
    }

    // Calculate a score based on delta values
    public float calculateScore() {
        int number = 0;
        float total = 0, average = 0;

        for(int x = 0; x < deltaAvs.size(); x++){
            total += deltaAvs.get(x);
            number++;
        }

        if(number != 0) {
            average = total / (float) number;
        }

        return average;
    }

    // Create a file in internal storage
    public void makeFile(){
        updating = false;
        String filename = "iFarmCSV.csv";
        String headline = "Index,X,Y,Z\n";
        String comma = ",";
        String newline = "\n";

        File myFile = new File(getFilesDir(), filename);

        FileOutputStream outputStream;
        try{
            outputStream = openFileOutput(filename, Context.MODE_PRIVATE);
            outputStream.write(headline.getBytes());
            for(int x = 0; x < dataPoints.size(); x++){
                outputStream.write(Integer.toString(x).getBytes());
                outputStream.write(comma.getBytes());
                outputStream.write(dataPoints.get(x).getxData().getBytes());
                outputStream.write(comma.getBytes());
                outputStream.write(dataPoints.get(x).getyData().getBytes());
                outputStream.write(comma.getBytes());
                outputStream.write(dataPoints.get(x).getzData().getBytes());
                outputStream.write(newline.getBytes());
            }
            outputStream.close();
        } catch (Exception e){
            e.printStackTrace();
        }
    }
}