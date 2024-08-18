# Webserver Access Log Analysis

## Top 5 IP Addresses

`awk '{print $1}' access.log | sort | uniq -c | sort -nr | head -5`

This command extracts the first column (IP addresses), sorts them, counts occurrences, and then sorts them in descending order to find the top 5.

**Results:**
1. 98.126.83.64: 278 requests
2. 13.212.235.168: 248 requests
3. 26.55.70.11: 153 requests
4. 3.58.246.203: 145 requests
5. 84.147.24.50: 140 requests

## Number of Requests with '200' and '500' HTTP Codes

```
grep -c ' 200 ' access.log
grep -c ' 500 ' access.log
```
`grep -c` counts occurrences of lines containing 200 and 500 status codes, which are key indicators of successful and server error responses, respectively.

**Results:**
- 200: 405 requests
- 500: 378 requests

## Number of Requests Per Minute

`awk '{print substr($4, 2, 17)}' access.log | sort | uniq -c | sort -nr`

 Extracts timestamps, sorts them, and counts the number of occurrences to find request frequency per minute.
 - `awk '{print substr($4, 2, 17)}'`: Extracts the timestamp, removing the leading [ and keeping the first 17 characters to include the date, hour, and minute.
- `sort | uniq -c:` Sorts the extracted timestamps and counts the number of occurrences per unique minute.
- `sort -nr:` Sorts the results numerically in descending order.

**Results:**   Peak times include 09:50, 09:53, and 09:55 with 392, 371, and 332 requests respectively.
1. 392 11/Aug/2024:09:50;
2. 371 11/Aug/2024:09:53;
3. 332 11/Aug/2024:09:55;
4. 273 11/Aug/2024:09:52;
5. 246 11/Aug/2024:09:49;
6. 241 11/Aug/2024:09:54;
7. 145 11/Aug/2024:09:56;

## Most Requested Domain

`awk '{for(i=1;i<=NF;i++) if ($i ~ /GET/) {print $(i+1)}}' access.log | cut -d'/' -f1 | sort | uniq -c | sort -nr | head -1`

 Identifies the most frequently requested domain, which is important for understanding traffic patterns.

- Uses `awk` to loop through each field of the log lines and find the `GET` keyword.
- Extracts the next field (which should be the domain).
- Uses `cut` to remove everything after the first `/`.
- Counts, sorts, and displays the most frequent domain.

**Result:** 
- example3.com with 1,036 requests

## Requests to `/page.php` Resulting in '499' Code

`grep '/page.php' access.log | awk '{print $9}' | sort | uniq`

Filters requests to `/page.php` and lists the unique status codes returned, checking for the prevalence of 499 responses.

**Result:** 
- There are multiple status codes returned for `/page.php`, not just `499`.

## Analysis and Observations

### Analyzing the Data:


- **IP Traffic Concentration:** The top 5 IP addresses account for a significant portion of the traffic. If these IPs are external, it might indicate a potential DDoS attack or bot activity. Analyzing the nature of these requests (e.g., user-agent strings) can help determine their intent.
- **High Number of '500' Errors:** A 500 status code typically indicates server-side issues. A higher-than-usual occurrence of these errors suggests potential server misconfiguration, application crashes, or overloads. Further investigation is required to pinpoint the root cause, such as reviewing server error logs or monitoring system performance.
- **Request Spikes:** The spikes in requests per minute, especially around specific times, could indicate either normal peak traffic (e.g., following an email campaign or social media post) or malicious activity like a brute-force attack. Analyzing the content of these requests and correlating them with external events is recommended.
- **Non-Uniform Status Codes for `/page.php:`** If requests to `/page.php` are not consistently returning 499, this may indicate variability in client behavior or server response issues that warrant further investigation.

### Pattern Recognition and Anomalies:

- **Consistent Patterns:** Regular traffic from certain IPs during specific times might be expected if these are from known users or services. However, if unexpected IPs or unusual traffic patterns are observed, this might suggest an anomaly.
- **Anomalies:** Any sharp deviations in traffic volume, error rates, or access patterns should be flagged for further investigation. Anomalies might also include unexpected HTTP methods, unusual file types being requested, or spikes in specific status codes.

### Recommendations and Actions:
Based on the analysis, recommend steps to address any issues or optimize the server's performance:

- **Mitigate Potential Attacks:** If suspect IPs are identified, consider blocking them or setting up rate limiting.
- **Server Health Monitoring:** Set up alerts for high 500 error rates or unusual traffic spikes.
- **Performance Tuning:** Analyze and optimize server and application performance during peak times to handle traffic better.