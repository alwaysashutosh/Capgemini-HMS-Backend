-- Capgemini HMS Database Schema for MySQL

-- 1. Independent Core Tables
CREATE TABLE physician (
    employeeid INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    position VARCHAR(255) NOT NULL,
    ssn INTEGER NOT NULL
);

CREATE TABLE nurse (
    employeeid INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    position VARCHAR(255) NOT NULL,
    registered BOOLEAN NOT NULL,
    ssn INTEGER NOT NULL
);

CREATE TABLE procedures (
    code INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    cost DECIMAL(10, 2) NOT NULL
);

CREATE TABLE medication (
    code INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    brand VARCHAR(255) NOT NULL,
    description TEXT NOT NULL
);

CREATE TABLE block (
    blockfloor INTEGER NOT NULL,
    blockcode INTEGER NOT NULL,
    PRIMARY KEY (blockfloor, blockcode)
);

-- 2. Tables with Primary Dependencies
CREATE TABLE department (
    departmentid INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    head INTEGER,
    FOREIGN KEY (head) REFERENCES physician(employeeid)
);

CREATE TABLE patient (
    ssn INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    phone VARCHAR(20) NOT NULL,
    insuranceid INTEGER NOT NULL,
    pcp INTEGER,
    FOREIGN KEY (pcp) REFERENCES physician(employeeid)
);

CREATE TABLE room (
    roomnumber INTEGER PRIMARY KEY,
    roomtype VARCHAR(255) NOT NULL,
    blockfloor INTEGER NOT NULL,
    blockcode INTEGER NOT NULL,
    unavailable BOOLEAN NOT NULL,
    FOREIGN KEY (blockfloor, blockcode) REFERENCES block(blockfloor, blockcode)
);

-- 3. Association and Scheduling Tables
CREATE TABLE affiliated_with (
    physician INTEGER,
    department INTEGER,
    primaryaffiliation BOOLEAN NOT NULL,
    PRIMARY KEY (physician, department),
    FOREIGN KEY (physician) REFERENCES physician(employeeid),
    FOREIGN KEY (department) REFERENCES department(departmentid)
);

CREATE TABLE trained_in (
    physician INTEGER,
    treatment INTEGER,
    certificationdate DATETIME NOT NULL,
    certificationexpires DATETIME NOT NULL,
    PRIMARY KEY (physician, treatment),
    FOREIGN KEY (physician) REFERENCES physician(employeeid),
    FOREIGN KEY (treatment) REFERENCES procedures(code)
);

CREATE TABLE appointment (
    appointmentid INTEGER PRIMARY KEY,
    patient INTEGER,
    prepnurse INTEGER,
    physician INTEGER,
    start DATETIME NOT NULL,
    `end` DATETIME NOT NULL,
    examinationroom TEXT NOT NULL,
    FOREIGN KEY (patient) REFERENCES patient(ssn),
    FOREIGN KEY (prepnurse) REFERENCES nurse(employeeid),
    FOREIGN KEY (physician) REFERENCES physician(employeeid)
);

CREATE TABLE stay (
    stayid INTEGER PRIMARY KEY,
    patient INTEGER,
    room INTEGER,
    staystart DATETIME NOT NULL,
    stayend DATETIME NOT NULL,
    FOREIGN KEY (patient) REFERENCES patient(ssn),
    FOREIGN KEY (room) REFERENCES room(roomnumber)
);

CREATE TABLE on_call (
    nurse INTEGER,
    blockfloor INTEGER NOT NULL,
    blockcode INTEGER NOT NULL,
    oncallstart DATETIME NOT NULL,
    oncallend DATETIME NOT NULL,
    PRIMARY KEY (nurse, blockfloor, blockcode, oncallstart, oncallend),
    FOREIGN KEY (nurse) REFERENCES nurse(employeeid),
    FOREIGN KEY (blockfloor, blockcode) REFERENCES block(blockfloor, blockcode)
);

-- 4. Prescriptions and Treatment Records
CREATE TABLE prescribes (
    physician INTEGER,
    patient INTEGER,
    medication INTEGER,
    date DATETIME NOT NULL,
    appointment INTEGER,
    dose TEXT NOT NULL,
    PRIMARY KEY (physician, patient, medication, date),
    FOREIGN KEY (physician) REFERENCES physician(employeeid),
    FOREIGN KEY (patient) REFERENCES patient(ssn),
    FOREIGN KEY (medication) REFERENCES medication(code),
    FOREIGN KEY (appointment) REFERENCES appointment(appointmentid)
);

CREATE TABLE undergoes (
    patient INTEGER,
    `procedure` INTEGER,
    stay INTEGER,
    dateundergoes DATETIME NOT NULL,
    physician INTEGER,
    assistingnurse INTEGER,
    PRIMARY KEY (patient, `procedure`, stay, dateundergoes),
    FOREIGN KEY (patient) REFERENCES patient(ssn),
    FOREIGN KEY (`procedure`) REFERENCES procedures(code),
    FOREIGN KEY (stay) REFERENCES stay(stayid),
    FOREIGN KEY (physician) REFERENCES physician(employeeid),
    FOREIGN KEY (assistingnurse) REFERENCES nurse(employeeid)
);
