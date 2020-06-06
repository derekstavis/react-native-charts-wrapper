package com.github.wuxudong.rncharts.charts;

import com.github.mikephil.charting.components.AxisBase;
import com.github.mikephil.charting.formatter.ValueFormatter;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class DynamicChartDateFormatter extends ValueFormatter {
    private Locale locale;

    long[] dates;

    public DynamicChartDateFormatter(long[] dates, Locale locale) {
        this.dates = dates;
        this.locale = locale;
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

        String pattern = getFormatPattern(date, previousDate);

        DateFormat dateFormat = new SimpleDateFormat(pattern, locale);
        return dateFormat.format(date);
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
    private String getFormatPattern(Date date1, Date date2) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date1);
        int year1 = calendar.get(Calendar.YEAR);
        int month1 = calendar.get(Calendar.MONTH);
        int day1 = calendar.get(Calendar.DAY_OF_MONTH);
        calendar.setTime(date2);
        int year2 = calendar.get(Calendar.YEAR);
        int month2 = calendar.get(Calendar.MONTH);
        int day2 = calendar.get(Calendar.DAY_OF_MONTH);

        if (year1 != year2) {
            return "yyyy";
        } else if (month1 != month2) {
            return "MMM";
        } else if (day1 != day2) {
            return "d";
        }
        return "HH:mm";
    }
}
