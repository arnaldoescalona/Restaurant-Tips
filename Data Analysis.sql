SELECT * FROM restaurant_tips.tips;

-- I first check that the data is cleaned, using this query on each non-double column. I also checked and there were no NULL values in either total_bill nor tip.
SELECT DISTINCT(day) FROM restaurant_tips.tips;

-- I'm going to analyze the tip, however, I believe it's important to also take into account the tip percentage. So I add another column.
ALTER TABLE restaurant_tips.tips
ADD tip_p DOUBLE;

UPDATE restaurant_tips.tips
SET tip_p = ROUND(tip/total_bill*100,2);

ALTER TABLE restaurant_tips.tips
MODIFY tip_p DOUBLE AFTER tip;

-- I look the average, maximum and minimum tip from the dataset. I decide to round to 2 decimals the AVG.
SELECT ROUND(AVG(tip),2), MIN(tip), MAX(tip) FROM restaurant_tips.tips;

-- I find the AVG, MAX, and MIN of the tip percentage as well.
SELECT ROUND(AVG(tip_p),2), MIN(tip_p), MAX(tip_p) FROM restaurant_tips.tips;

-- I find the averages of the tip total and tip percentage for each working day. 
SELECT day, ROUND(AVG(tip_p),2), ROUND(STDDEV_SAMP(tip_p), 2), COUNT(*)
FROM restaurant_tips.tips
GROUP BY day
ORDER BY ROUND(AVG(tip_p),2) DESC;

-- I do the same thing for the other variables. e.g.: time, size, smoker and sex.
SELECT time, ROUND(AVG(tip_p),2), ROUND(STDDEV_SAMP(tip_p), 2), COUNT(*)
FROM restaurant_tips.tips
GROUP BY time
ORDER BY ROUND(AVG(tip_p),2) DESC;

SELECT size, ROUND(AVG(tip_p),2), ROUND(STDDEV_SAMP(tip_p), 2), COUNT(*)
FROM restaurant_tips.tips
GROUP BY size
ORDER BY ROUND(AVG(tip_p),2) DESC;

SELECT smoker, ROUND(AVG(tip_p),2), ROUND(STDDEV_SAMP(tip_p), 2), COUNT(*)
FROM restaurant_tips.tips
GROUP BY smoker
ORDER BY ROUND(AVG(tip_p),2) DESC;

SELECT sex, ROUND(AVG(tip_p),2), ROUND(STDDEV_SAMP(tip_p), 2), COUNT(*)
FROM restaurant_tips.tips
GROUP BY sex
ORDER BY ROUND(AVG(tip_p),2) DESC;


-- I see that the people who come alone are the ones that give the better tips.
-- I want to check whether the single men or single women are the best tippers.
-- I use COUNT(*) in order to see how many men and women came, and see that I have data of only 1 man and 3 women
SELECT sex, ROUND(AVG(tip_p),2), COUNT(*)
FROM restaurant_tips.tips
WHERE size = 1
GROUP BY sex
ORDER BY ROUND(AVG(tip_p),2) DESC;

-- At this point, I went back and looked for the Standard Deviation and Count of all the previous variables.
-- For the sake of brevity, I added it to the previous section.

-- I finally calculated the correlation coefficient for both tip total and tip percentage. Both variables being correlated with the total bill.
SELECT 
    (COUNT(*) * SUM(total_bill * tip) - SUM(total_bill) * SUM(tip)) / 
    (SQRT(
        (COUNT(*) * SUM(total_bill * total_bill) - POW(SUM(total_bill), 2)) * (COUNT(*) * SUM(tip * tip) - POW(SUM(tip), 2))
    )) AS correlation_coefficient
FROM restaurant_tips.tips;

SELECT 
    (COUNT(*) * SUM(total_bill * tip_p) - SUM(total_bill) * SUM(tip_p)) / 
    (SQRT(
        (COUNT(*) * SUM(total_bill * total_bill) - POW(SUM(total_bill), 2)) * (COUNT(*) * SUM(tip_p * tip_p) - POW(SUM(tip_p), 2))
    )) AS correlation_coefficient
FROM restaurant_tips.tips;
