package org.example.springboot.util;

import java.time.LocalDate;

public class DateUtils {
    /**
     * 璁＄上个月的�涓�澶┿�?
     * @return 上个月��涓�澶╃殑LocalDate瀵硅薄銆?
     */
    public static LocalDate getLastMonthFirstDay() {
        LocalDate today = LocalDate.now(); // 获取当前日期
        int currentMonth = today.getMonthValue(); // 获取当前月份
        int currentYear = today.getYear(); // 获取当前年份

        // 如果当前月份?月，则上�鏈堟槸鍘诲勾鐨�12鏈?
        if (currentMonth == 1) {
            return LocalDate.of(currentYear - 1, 12, 1);
        } else {
            // 鍚﹀，上�鏈堢殑绗�涓�澶╁氨鏄�当前年加上上�鏈堢殑鏈堜唤鍑?，日期为1
            return LocalDate.of(currentYear, currentMonth - 1, 1);
        }
    }
}
