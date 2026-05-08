
# **Architecture**

**Online Boutique** is composed of 11 microservices written in different languages that talk to each other over gRPC.

![image.png](docs/images/Architecture01.png)

| **Service** | **Language** | **Description** |
| --- | --- | --- |
| [frontend](https://github.com/laxmikantagiri/Production-Grade_GitOps-Driven_Microservices-Demo/blob/main/src/frontend) | Go | Exposes an HTTP server to serve the website. Does not require signup/login and generates session IDs for all users automatically. |
| [cartservice](https://github.com/laxmikantagiri/Production-Grade_GitOps-Driven_Microservices-Demo/blob/main/src/cartservice) | C# | Stores the items in the user's shopping cart in Redis and retrieves it. |
| [productcatalogservice](https://github.com/laxmikantagiri/Production-Grade_GitOps-Driven_Microservices-Demo/blob/main/src/productcatalogservice) | Go | Provides the list of products from a JSON file and ability to search products and get individual products. |
| [currencyservice](https://github.com/laxmikantagiri/Production-Grade_GitOps-Driven_Microservices-Demo/blob/main/src/currencyservice) | Node.js | Converts one money amount to another currency. Uses real values fetched from European Central Bank. It's the highest QPS service. |
| [paymentservice](https://github.com/laxmikantagiri/Production-Grade_GitOps-Driven_Microservices-Demo/blob/main/src/paymentservice) | Node.js | Charges the given credit card info (mock) with the given amount and returns a transaction ID. |
| [shippingservice](https://github.com/laxmikantagiri/Production-Grade_GitOps-Driven_Microservices-Demo/blob/main/src/shippingservice) | Go | Gives shipping cost estimates based on the shopping cart. Ships items to the given address (mock) |
| [emailservice](https://github.com/laxmikantagiri/Production-Grade_GitOps-Driven_Microservices-Demo/blob/main/src/emailservice) | Python | Sends users an order confirmation email (mock). |
| [checkoutservice](https://github.com/laxmikantagiri/Production-Grade_GitOps-Driven_Microservices-Demo/blob/main/src/checkoutservice) | Go | Retrieves user cart, prepares order and orchestrates the payment, shipping and the email notification. |
| [recommendationservice](https://github.com/laxmikantagiri/Production-Grade_GitOps-Driven_Microservices-Demo/blob/main/src/recommendationservice) | Python | Recommends other products based on what's given in the cart. |
| [adservice](https://github.com/laxmikantagiri/Production-Grade_GitOps-Driven_Microservices-Demo/blob/main/src/adservice) | Java | Provides text ads based on given context words. |
| [loadgenerator](https://github.com/laxmikantagiri/Production-Grade_GitOps-Driven_Microservices-Demo/blob/main/src/loadgenerator) | Python/Locust | Continuously sends requests imitating realistic user shopping flows to the frontend. |

Screenshots:

![image.png](docs/images/Screenshot01.png)

---

## Service-by-Service Data Breakdown

### ✅ **cartservice** → ✔️ HAS persistence

**Storage used:**

- **Redis**

**What’s stored:**

- User cart items
- Quantity, product IDs

**Why Redis?**

- Fast
- Simple
- Easy to reset
- No schema complexity

📌 In Kubernetes:

- Redis runs as a pod (or StatefulSet)
- Cart data is lost if Redis is deleted (by default)

---

### ❌ **orders / checkout** → NO real database

There is **NO dedicated “orders database”**.

**checkoutservice:**

- Aggregates data from:
    - cartservice
    - paymentservice
    - shippingservice
    - emailservice
- Simulates order placement
- Does **not persist orders**

👉 This is **by design**, to keep the demo lightweight.

---

### ❌ **productcatalogservice**

**Storage:**

- Static JSON file
- Loaded into memory at startup

**No DB**

- Products reset on restart

---

### ❌ **recommendationservice**

**Storage:**

- Stateless
- Generates recommendations dynamically

---

### ❌ **paymentservice**

**Storage:**

- None
- Fake payment processor

---

### ❌ **shippingservice**

**Storage:**

- None
- Simulated shipping cost logic

---

### ❌ **emailservice**

**Storage:**

- None
- Just logs “email sent”

---

### ❌ **adservice**

**Storage:**

- In-memory ad data
- No persistence

---

### ❌ **frontend**

**Storage:**

- Stateless
- Just UI + API calls

---

### ❌ **currencyservice**

**Storage:**

- Static exchange rates
- In-memory only

---

## SUMMARY TABLE

| Service | Persistent Storage | Type |
| --- | --- | --- |
| cartservice | ✅ Yes | Redis |
| checkoutservice | ❌ No | Stateless |
| productcatalogservice | ❌ No | In-memory JSON |
| recommendationservice | ❌ No | Stateless |
| paymentservice | ❌ No | Fake |
| shippingservice | ❌ No | Fake |
| emailservice | ❌ No | Fake |
| adservice | ❌ No | In-memory |
| frontend | ❌ No | Stateless |
| currencyservice | ❌ No | In-memory |
| loadgenerator | ❌ No | Stateless |


# Project Architecture

![Gitops Project.gif](docs/images/Gitops_Project.gif)

![Gitops Project.drawio.png](docs/images/Gitops_Project.png)
---

# GitHub Actions CI pipeline 

![CI pipeline](docs/images/Screenshot%202026-05-08%20005129.png)
---

# ArgoCD 

![ArgoCD](docs/images/Screenshot%202026-05-08%20013318.png)

## ArgoCD image updater updating the latest push image tag 

![ArgoCD](docs/images/Screenshot%202026-05-08%20014233.png)
---

# app running on domain with secured connection 

![ArgoCD](docs/images/Screenshot%202026-05-08%20014445.png)
---

# Grafana Dashboard

![ArgoCD](docs/images/Screenshot%202026-05-08%20020656.png)
![ArgoCD](docs/images/Screenshot%202026-05-08%20020810.png)
![ArgoCD](docs/images/Screenshot%202026-05-08%20020937.png)
---

# Promethus

![promethus](docs/images/Screenshot%202026-05-08%20021200.png)
![promethus](docs/images/Screenshot%202026-05-08%20021307.png)
---

# Logging
# Kibana Dashboard 

![kibana](docs/images/Screenshot%202026-05-08%20025131.png)
![kibana](docs/images/Screenshot%202026-05-08%20025411.png)
![kibana](docs/images/Screenshot%202026-05-08%20025620.png)
---

# Slack channel for alertmanager

![kibana](docs/images/Screenshot%202026-05-08%20025946.png)
---

# Recordset update by External DNS in Route53

![DNS](docs/images/Screenshot%202026-05-08%20025822.png)
---
