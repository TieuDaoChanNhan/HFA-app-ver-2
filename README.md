# Health For All (HFA) - A Healthcare App for Remote Health Monitoring and Support

**Health For All (HFA)** is an innovative mobile application designed to improve access to healthcare for underserved communities, such as the elderly, disabled, and individuals in remote or low-income areas. The app allows users to monitor their health, securely store medical data, and easily connect with healthcare professionals for consultation and diagnosis.

---

## Key Features

### Hardware Integration
The app integrates with a compact and portable health monitoring device that tracks multiple critical health metrics, including:
- **SPO2 (Blood Oxygen Saturation)**
- **Heart Rate**
- **ECG (Electrocardiogram)**
- **Heart-Lung Sounds**
- **Temperature**

Data is wirelessly transmitted to the app, allowing users to monitor their health and share the results with doctors for expert evaluation.

### App Features
- **User Profile Management**: Create and manage personalized health profiles.
- **Health Record Management**: Organize and display health data from the monitoring device.
- **Doctor Connectivity**: Enable remote consultations with healthcare professionals.
- **Prescription Management**: Scan, store, and manage prescriptions.
- **Reminders**: Notify users to take medications or perform health measurements.
- **Health Alerts**: Inform users of critical health data.
- **Chatbot Assistance**: Offer basic health advice and app guidance.

---

## Technologies Used

### 1. **Frontend Development**
- **Flutter**: Used for cross-platform app development, enabling the app to run seamlessly on Android, iOS, and web platforms.  
- **Material Design**: Ensures a modern and user-friendly interface.  
- **fl_chart**: Displays dynamic and interactive ECG-style graphs with over 500 data points.

### 2. **Backend Development**
- **Firebase**: 
  - Real-time database management for storing and synchronizing user data securely.
  - Handles authentication, ensuring reliable and secure user sign-ins.
  - Cloud Firestore: Organizes and retrieves health records and other app data efficiently.

### 3. **Data Communication**
- **Bluetooth Low Energy (BLE)**: Enables efficient and real-time communication between the health monitoring device and the app.

### 4. **Authentication**
- **Google OAuth**: Allows secure and seamless user login.

### 5. **Image Processing**
- **YOLOv8 Model**: Utilized for identifying and analyzing specific regions in scanned prescriptions, ensuring accurate data extraction.

### 6. **Audio Integration**
- **just_audio Package**: Allows playback of recorded heart-lung sound files in the app.

### 7. **Link Handling**
- **app_links**: Handles deep linking to integrate the app with external resources, such as Samsung Health via Health Connect.

---

## Impact and Necessity
HFA addresses healthcare access disparities by enabling:
- Remote monitoring for users in rural or underserved areas.
- Convenient communication between patients and healthcare providers.
- Improved health outcomes through timely interventions and continuous monitoring.

---

## Target Audience
- **Elderly Individuals**: Reduce travel for healthcare.
- **Low-Income Communities**: Affordable remote healthcare.
- **Chronic Condition Patients**: Regular health monitoring.

---

## Download the App
The HFA app is available for download:  
[**Download HFA App**](https://drive.google.com/file/d/12APl8KQVNFzLmk2Lk6lEC6o_Q6Jbc7QD/view?usp=sharing)

---

## Demo Product
Explore our product in action through this demo:  
[**View Product Demo**](https://drive.google.com/file/d/18a_q0sjvQaTyZBtsHXaLK_Y6TH_4S4uc/view?usp=sharing)

---

## Figma Design
Explore our app design:  
[**View App Design**](https://www.figma.com/design/CVCKjBexxaHIwTamQiMnPX/HealthForAll-App)

---

## Additional Resources
- **SFT Research Resource**: [**Access SFT Research**](https://drive.google.com/drive/u/0/folders/1urGEq8EOp1WiWo0_IhsH_1f-cnUYpnIf)  
- **More Details About the Project**: [**Project Details**](https://drive.google.com/drive/u/0/folders/1dB_FHNnQ1XOn9a3TZfbFJOewPzvK6S1V)

---

## Future Developments
HFA is evolving, with plans to:
- Enhance device capabilities for additional health metrics.
- Expand the app’s functionality to integrate advanced health analysis.
- Collaborate with medical institutions to enrich features and improve accessibility.
