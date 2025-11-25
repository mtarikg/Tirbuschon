# Tirbuschon (Graduation Project)

## 1. Definition
A cross-platform booking application, developed using Flutter and Firebase.

## 2. Stakeholders
The project supports three types of users, Admin, Customer and Venue, whose capabilities are described below:

<img width="650" height="550" src="https://github.com/user-attachments/assets/35c73e6f-30d4-4c6a-bbe2-cf8b4b14b688" />

## 3. System Behavior
Below are the state diagrams for each user type, showing how the system behaves and transitions between states in response to their actions.

### 3.1 Customer
<img width="650" height="650" src="https://github.com/user-attachments/assets/77a182d0-4b53-4d98-9144-5321f07fef36" />

#### Key Points:
- The customer must login to search for venues and make reservations.

### 3.2 Venue
<img width="650" height="650" src="https://github.com/user-attachments/assets/852df5ec-f8eb-4665-9c45-d23a9c9886d8" />

## 4. User Interface
Key screens from the application are highlighted below.

### 4.1 Customer
<p float="left">
  <img width="300" height="600" src="https://github.com/user-attachments/assets/c8d6bd23-09bb-4dcd-a7df-8aaa0017ad54" />
  <img width="300" height="600" src="https://github.com/user-attachments/assets/3db53b48-4071-43b5-9d04-c49dcb15c584" />
  <img width="300" height="600" src="https://github.com/user-attachments/assets/7b3924a5-dc28-48de-bde4-85f08f6f18d9" />
  <img width="300" height="600" src="https://github.com/user-attachments/assets/bb709275-320f-4d98-ab29-a5276175d6e8" />
  <img width="300" height="600" src="https://github.com/user-attachments/assets/3ee120e0-4e67-478f-a6f0-ee99f95c0cc0" />
  <img width="300" height="600" src="https://github.com/user-attachments/assets/0caf2cca-2dce-415d-9d22-f32852a5c898" />
  <img width="300" height="600" src="https://github.com/user-attachments/assets/85a698f7-043a-47cf-a55e-d4e379202456" />
</p>

### 4.2 Venue
<p float="left">
  <img width="300" height="600" src="https://github.com/user-attachments/assets/15a0e9ab-919b-49c9-8834-ef031180d999" />
  <img width="300" height="600" src="https://github.com/user-attachments/assets/256f795a-d6a5-4087-b79f-9b6e81203fec" />
  <img width="300" height="600" src="https://github.com/user-attachments/assets/cd07620d-41d0-49fe-9ec7-987f4150b399" />
  <img width="300" height="600" src="https://github.com/user-attachments/assets/ed306941-f533-4120-a95c-f7589fbb0d14" />
  <img width="300" height="600" src="https://github.com/user-attachments/assets/5e495994-b510-4e1d-837e-626448c57362" />
</p>

### 4.3 Admin
<p float="left">
  <img width="300" height="600" src="https://github.com/user-attachments/assets/ea7f73c4-1ebe-4528-b148-092af81341e4" />
  <img width="300" height="600" src="https://github.com/user-attachments/assets/c85d0115-7481-42f2-8271-689b5ff30397" />
</p>

## 5. Database Design
Although Cloud Firestore is a NoSQL database, the entities are modeled as if for a relational system, as shown in the following Entity-Relationship Diagram (ERD):

<img width="700" height="500" src="https://github.com/user-attachments/assets/ed5d1764-b3c5-4aa6-ae18-8196399bc250" />

## 6. Conclusion
This project delivers a cross-platform booking app built with Flutter and Firebase, offering clear workflows for Admin, Customer, and Venue users. It features an intuitive interface, structured database design, and well-defined system behavior to support reservations and management.
