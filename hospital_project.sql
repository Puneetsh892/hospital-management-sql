CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10),
    date_of_birth DATE,
    phone VARCHAR(15),
    city VARCHAR(50)
);

CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    phone VARCHAR(15)
);

CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id) ON DELETE CASCADE,
    doctor_id INT REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    appointment_date DATE NOT NULL,
    status VARCHAR(20)
);

CREATE TABLE prescriptions (
    prescription_id SERIAL PRIMARY KEY,
    appointment_id INT REFERENCES appointments(appointment_id) ON DELETE CASCADE,
    medicine_name VARCHAR(100),
    dosage VARCHAR(50),
    days INT
);

-- Patients (10)
INSERT INTO patients (full_name, gender, date_of_birth, phone, city) VALUES
('Rahul Sharma','Male','1995-05-10','9876543210','Delhi'),
('Priya Singh','Female','1998-08-15','9876543211','Noida'),
('Amit Verma','Male','1990-03-20','9876543212','Delhi'),
('Neha Gupta','Female','1997-11-25','9876543213','Gurgaon'),
('Ravi Kumar','Male','1985-07-30','9876543214','Delhi'),
('Anjali Mehta','Female','1992-01-18','9876543215','Noida'),
('Suresh Yadav','Male','1988-06-12','9876543216','Ghaziabad'),
('Kiran Patel','Female','1994-09-09','9876543217','Delhi'),
('Vikas Jain','Male','1991-12-22','9876543218','Noida'),
('Pooja Kapoor','Female','1996-04-05','9876543219','Delhi');

-- Doctors (5)
INSERT INTO doctors (doctor_name, specialization, phone) VALUES
('Dr. Mehta','Cardiologist','9991111111'),
('Dr. Sharma','Dermatologist','9992222222'),
('Dr. Khan','Orthopedic','9993333333'),
('Dr. Singh','Pediatrician','9994444444'),
('Dr. Verma','Neurologist','9995555555');

-- Appointments (20)
INSERT INTO appointments (patient_id, doctor_id, appointment_date, status) VALUES
(1,1,'2026-07-01','Completed'),
(2,2,'2026-07-02','Completed'),
(3,3,'2026-07-03','Cancelled'),
(4,4,'2026-07-04','Completed'),
(5,5,'2026-07-05','Completed'),
(6,1,'2026-07-06','Pending'),
(7,2,'2026-07-07','Completed'),
(8,3,'2026-07-08','Completed'),
(9,4,'2026-07-09','Pending'),
(10,5,'2026-07-10','Completed'),
(1,2,'2026-07-11','Completed'),
(2,3,'2026-07-12','Completed'),
(3,4,'2026-07-13','Completed'),
(4,5,'2026-07-14','Pending'),
(5,1,'2026-07-15','Completed'),
(6,2,'2026-07-16','Cancelled'),
(7,3,'2026-07-17','Completed'),
(8,4,'2026-07-18','Completed'),
(9,5,'2026-07-19','Completed'),
(10,1,'2026-07-20','Pending');

-- Prescriptions (15)
INSERT INTO prescriptions (appointment_id, medicine_name, dosage, days) VALUES
(1,'Paracetamol','500mg',5),
(2,'Ibuprofen','400mg',3),
(4,'Amoxicillin','250mg',7),
(5,'Cetirizine','10mg',5),
(7,'Metformin','500mg',10),
(8,'Atorvastatin','20mg',15),
(10,'Aspirin','75mg',10),
(11,'Pantoprazole','40mg',5),
(12,'Dolo','650mg',3),
(13,'Azithromycin','500mg',5),
(15,'Vitamin D','60000IU',4),
(17,'Calcium','500mg',10),
(18,'Crocin','500mg',3),
(19,'ORS','1 packet',2),
(20,'Insulin','10 units',30);
-- Insert
INSERT INTO patients (full_name, gender, date_of_birth, phone, city)
VALUES ('New Patient','Male','2000-01-01','9998887776','Delhi');

-- Update
UPDATE patients SET phone = '9990001111' WHERE patient_id = 1;

-- Delete cancelled appointment
DELETE FROM appointments WHERE status = 'Cancelled';

-- Select all doctors
SELECT * FROM doctors;

SELECT * FROM patients WHERE city IN ('Delhi','Noida');

SELECT * FROM appointments
WHERE appointment_date BETWEEN '2026-07-01' AND '2026-07-31';

SELECT * FROM doctors WHERE specialization LIKE '%Cardio%';

SELECT * FROM patients ORDER BY full_name LIMIT 5;

-- INNER JOIN
SELECT p.full_name, d.doctor_name, a.appointment_date
FROM appointments a
INNER JOIN patients p ON a.patient_id = p.patient_id
INNER JOIN doctors d ON a.doctor_id = d.doctor_id;

-- LEFT JOIN
SELECT p.full_name, a.appointment_id
FROM patients p
LEFT JOIN appointments a ON p.patient_id = a.patient_id;

---Aggregate Functions
SELECT COUNT(*) FROM appointments;

SELECT AVG(EXTRACT(YEAR FROM AGE(date_of_birth))) FROM patients;

SELECT MIN(appointment_date), MAX(appointment_date) FROM appointments;

---GROUP BY & HAVING
SELECT doctor_id, COUNT(*) AS total_appointments
FROM appointments
GROUP BY doctor_id;

SELECT doctor_id, COUNT(*)
FROM appointments
GROUP BY doctor_id
HAVING COUNT(*) > 3;

-- View
CREATE VIEW appointment_details AS
SELECT p.full_name, d.doctor_name, a.appointment_date, a.status
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id;

-- Index
CREATE INDEX idx_patient_name ON patients(full_name);

-- Subquery
SELECT patient_id, COUNT(*) AS visits
FROM appointments
GROUP BY patient_id
HAVING COUNT(*) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM appointments
        GROUP BY patient_id
    ) sub
);


-- Daily report
SELECT appointment_date, COUNT(*) FROM appointments
GROUP BY appointment_date;

-- Doctor-wise patient count
SELECT doctor_id, COUNT(DISTINCT patient_id)
FROM appointments
GROUP BY doctor_id;

-- Top 5 busiest doctors
SELECT doctor_id, COUNT(*) AS total
FROM appointments
GROUP BY doctor_id
ORDER BY total DESC
LIMIT 5;

-- Patients with no appointments
SELECT * FROM patients
WHERE patient_id NOT IN (SELECT DISTINCT patient_id FROM appointments);

-- Complete medical history
SELECT p.full_name, a.appointment_date, pr.medicine_name
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
JOIN prescriptions pr ON a.appointment_id = pr.appointment_id;
SELECT * FROM patients;