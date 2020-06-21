package com.github.wuxudong.rncharts.charts;

import com.github.mikephil.charting.components.AxisBase;
import com.github.mikephil.charting.formatter.ValueFormatter;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class DynamicChartDateFormatter extends ValueFormatter {
    private SimpleDateFormat mSimpleDateFormat;
    private Calendar mCalendar = Calendar.getInstance();

    long[] dates;

    public DynamicChartDateFormatter(long[] dates, Locale locale) {
        this.dates = dates;
        this.mSimpleDateFormat = new SimpleDateFormat("HH:mm", locale);
    }

    @Override
    public String getAxisLabel(float value, AxisBase axis) {
        int dateIndex = Math.abs(Math.round(value));

        if (dateIndex < 0 || dateIndex >= dates.length)
            return "";

        Date date = new Date(dates[dateIndex]);

        int entryIndex = getEntryIndexForValue(value, axis);

        if (entryIndex < 0) {
            return "";
        }

        if (entryIndex == 0) {
            int entryInterval = (int) Math.abs(axis.mEntries[1] - axis.mEntries[0]);
            int previousDateIndex = dateIndex + entryInterval;

            return formatByPreviousDateIndex(previousDateIndex, date);
        }

        int previousDateIndex = Math.abs(Math.round(axis.mEntries[entryIndex - 1]));
        return formatByPreviousDateIndex(previousDateIndex, date);
    }

    private String formatByPreviousDateIndex(int previousDateIndex, Date date) {
        if (previousDateIndex < 0 || previousDateIndex >= dates.length)
            return "";

        Date previousDate = new Date(dates[previousDateIndex]);

        getFormatPattern(date, previousDate);

        return mSimpleDateFormat.format(date);
    }

    private int getEntryIndexForValue(float value, AxisBase axis) {
        for (int i = 0; i < axis.mEntryCount; i++) {
            if (value == axis.mEntries[i]) {
                return i;
            }
        }
        return -1;
    }

    // If value diff > year
    // return year number
    // If value diff > month
    // return month number
    // If value diff > day
    // return day number
    // else
    // return HH:mm
    private void getFormatPattern(Date date1, Date date2) {
        mCalendar.setTime(date1);
        int year1 = mCalendar.get(Calendar.YEAR);
        int month1 = mCalendar.get(Calendar.MONTH);
        int day1 = mCalendar.get(Calendar.DAY_OF_MONTH);
        mCalendar.setTime(date2);
        int year2 = mCalendar.get(Calendar.YEAR);
        int month2 = mCalendar.get(Calendar.MONTH);
        int day2 = mCalendar.get(Calendar.DAY_OF_MONTH);

        if (year1 != year2) {
            mSimpleDateFormat.applyPattern("yyyy");
        } else if (month1 != month2) {
            mSimpleDateFormat.applyPattern("MMM");
        } else if (day1 != day2) {
            mSimpleDateFormat.applyPattern("d");
        } else {
            mSimpleDateFormat.applyPattern("HH:mm");
        }
    }
}
