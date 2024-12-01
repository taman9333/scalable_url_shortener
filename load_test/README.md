# Load Testing Scripts

This directory contains two load testing scripts to evaluate the performance and behavior of the URL shortener service under different scenarios:

1. **Single Instance Test:** Tests the performance of a single server instance to measure its throughput and latency under varying loads.
2. **Two Instances Test:** Tests the behavior of two server instances running concurrently. This ensures that:
   - Both servers can work seamlessly together.
   - They coordinate properly to obtain counter ranges from etcd.
   - When the counter range is exhausted, both servers can request and allocate a new range without issues.

---

## Results and Observations

### **Single Server Performance**

For this test, we evaluated the performance of the service using two different web servers: **Puma** and **Falcon**. Below are the results:

#### **Puma Results**
1. **100 Virtual Users for 1 Second(ScreenShot: puma1.png):**
   - **RPS (Requests Per Second):** 2,550/s
   - **Request Duration (Average):** 27 ms
   - **Request Duration (Max):** 460 ms

2. **500 Virtual Users for 1 Second(ScreenShot: puma2.png):**
   - **RPS (Requests Per Second):** 1,160/s
   - **Request Duration (Average):** 256 ms
   - **Request Duration (Max):** 2.24 s

While Puma performs reasonably well under moderate loads, the performance degrades significantly as the number of concurrent virtual users increases.

#### **Falcon Results**
1. **100 Virtual Users for 1 Second(ScreenShot: falcon1.png):**
   - **RPS (Requests Per Second):** 9,055/s
   - **Request Duration (Average):** 11 ms
   - **Request Duration (Max):** 93 ms

2. **500 Virtual Users for 1 Second(ScreenShot: falcon2.png):**
   - **RPS (Requests Per Second):** 8,000/s
   - **Request Duration (Average):** 45 ms
   - **Request Duration (Max):** 209 ms

Falcon demonstrates significantly better performance, maintaining high throughput (RPS) and low latency, even under increased stress with 500 virtual users.

---

### **Two-Server Instance Test**

This test ensures that the system can:
- Distribute load between two instances running concurrently.
- Coordinate counter range allocation from etcd without conflicts.
- Handle counter range exhaustion by requesting a new range seamlessly.

Both instances worked correctly, demonstrating that the service can scale horizontally while maintaining reliable operation.

---

## Choosing Falcon

Based on the performance metrics and the nature of the workload, Falcon was chosen as the web server for the following reasons:

1. **High Throughput:** Falcon consistently delivers a higher RPS compared to Puma, even under heavy load.
2. **Low Latency:** Falcon maintains significantly lower average and maximum response times, ensuring a better user experience.
3. **Optimized for Concurrent Requests:** Falcon is designed for handling high-concurrency scenarios, making it ideal for a URL shortener service that expects a large volume of requests.

---

## How to Run the Scripts

### **Prerequisites**
- Ensure you have docker on your system as we will run `k6` using docker.
- The servers and etcd should be running and properly configured.

### **Running the Single Server Test**
1. Start the web server in one terminal window
  ```bash
     docker-compose up url-shortener-1
  ```
2. Run `k6` command for load testing; please make sure you add --platform linux/amd64 if you are using mac with M chip
   ```bash
    docker run --platform linux/amd64 -i loadimpact/k6 run - < load_test/one_instance.js
   ```

### **Running the Two-Server Test**
1. Start the two instances in two different terminal windows
  ```bash
     docker-compose up url-shortener-1
     docker-compose up url-shortener-2
  ```
2. Run `k6` command for load testing; please make sure you add --platform linux/amd64 if you are using mac with M chip
   ```bash
    docker run --platform linux/amd64 -i loadimpact/k6 run - < load_test/two_instances.js
   ```
