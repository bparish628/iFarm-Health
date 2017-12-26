package com.unmc.ifarmhealth;

public class dataPoint {
    private double xData;
    private double yData;
    private double zData;

    public String getxData() {
        return Double.toString(this.xData);
    }

    public void setxData(double xData) {
        this.xData = xData;
    }

    public String getyData() {
        return Double.toString(this.yData);
    }

    public void setyData(double yData) {
        this.yData = yData;
    }

    public String getzData() {
        return Double.toString(this.zData);
    }

    public void setzData(double zData) {
        this.zData = zData;
    }
}
