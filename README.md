# Vodafone Foundation Instant Network Schools (INS)
## Multi-Center Inventory & Pedagogical Activities Management System

An offline-first, production-ready Progressive Web Application (PWA) built specifically for Vodafone Foundation's multi-center educational network (9+ classrooms/centers).

---

## 🌟 Key Capabilities

### 1. Serial Number-First Device Registry
- Tracks all hardware assets by physical **Serial Numbers (SN)** (e.g. `2DKNU20920100431`, `1115738756`, `PJ-EPSON-77821`).
- Hardware categories:
  - **Ned Boxes** (Educational offline server running Milliweb + Wi-Fi router)
  - **Student & Teacher Tablets**
  - **Laptops / Workstations**
  - **Classroom Projectors**
  - **Charging Carts / Multi-chargers**
  - **Accessories, Speakers & Network gear**
- Real-time statuses: `Operational`, `Needs Repair`, `Broken / Damaged`, `Lost`, `Stolen`, `Misplaced`, `In Storage`.

### 2. Pedagogical Activities & Milliweb 6-Digit Codes
- **Classroom Teaching Sessions (Main Activity)**:
  - Records Teacher Name, Center, Date & Day, Start/End Time, Duration.
  - Topic taught and linked **6-digit Milliweb Lesson Code** (e.g. `482910`).
  - Attendance breakdown by gender: **Male Students** & **Female Students**.
  - Technology checkboxes: 1-to-1 Tablets, Projector, Ned Box Milliweb server, Audio/Speakers, and **Teacher's Own Personal Device flag**.
- **Teacher Preparation Day (Friday / Scheduled Sessions)**:
  - Logs Teacher Name, Session (Morning/Afternoon), Number of lessons prepared.
  - Ned Box Offline Server confirmation: **Stored in Milliweb server (`Yes`/`No`)**.
  - Encodes & cataloges **6-digit unique Milliweb Lesson Codes** with Subject, Grade, and Topic.
- **Student Independent Research & Note-Taking**:
  - Independent self-study logs with 6-digit Milliweb code lookups and Male/Female counts.
- **Community Digital Access & Specialized Tasks**:
  - Open lab internet browsing, digital literacy, job applications, and **video / multimedia production tasks**.

### 3. Device Withdrawal / Charging / Checkout Register
- Captures Date, Beneficiary Full Name, Sex (Male/Female), Address/Class/Block, Device Type & Serial Number, Withdrawal Time, Expected Return Time, and Actual Return Time.
- Includes **Digital Acknowledgement & Verification Tick Box** (signature substitute) and condition assessment upon return.

### 4. Incident & Maintenance Ticketing
- Log issues: `Broken / Damaged Screen`, `Needs Repair / Battery Degradation`, `Lost Device`, `Stolen Device`, `Misplaced / Missing in Audit`.
- Severity levels (`Low`, `Medium`, `High`, `Critical`), resolution notes, and automatic status updates in the device registry.

### 5. Multi-Center & Coach Directory
- Supports **9+ Vodafone Foundation Centers/Classrooms** (e.g. Kakuma Central, Kalobeyei Lab, Dadaab Hub, Nyarugusu School, Minawao, Tongogara, Dzaleka, Mahama, Kyaka).
- Assigns 2 to 3 coaches per center with roles (`Lead Digital Coach`, `Assistant Coach`, `Technical Coach`), contact numbers, and custody responsibility.

### 6. Executive Multi-Period Report Generator
- Filters: **Daily, Weekly, Bi-Weekly (2 weeks), Monthly, and Custom Date Ranges**.
- Generates structured operational and donor reports:
  - **Gender Disaggregation**: Total Beneficiaries, Female Count, Male Count, % Female Participation.
  - **Teaching Analytics**: Total Sessions, Teaching Hours, Average Class Size.
  - **Technology Utilization**: % Tablets (1-to-1), % Projector, % Ned Box Offline Server, % Teacher Personal Devices.
  - **Preparation Metrics**: Lessons prepared and Milliweb 6-digit code compliance.
- Export options:
  - **1-Click Official Printable / PDF-ready View** (`Ctrl + P` / Print button with official header and signature lines).
  - **CSV Export**.
  - **Direct Sync to Google Sheets**.

### 7. 100% Offline-First Engine & Google Sheets Auto-Sync
- **IndexedDB**: All records are stored safely in the client browser/tablet storage.
- **PWA Service Worker**: Operates seamlessly in classrooms with zero internet connection.
- **Outbox Sync Engine**: When the device detects internet, queued offline mutations automatically sync in the background to Google Sheets.
- **Google Apps Script Backend (`Code.gs`)**: 1-click deployable script that creates and synchronizes all Google Sheet tabs.

---

## 🚀 How to Run Locally

Because the application is built with standard web technologies (HTML5, Vanilla JavaScript, CSS3, IndexedDB, Service Worker), you can open it directly or serve it:

### Option 1: Direct Browser Launch
Double-click `index.html` or open it in Google Chrome, Microsoft Edge, Firefox, or Safari on desktop or tablet.

### Option 2: Local HTTP Server (e.g. VS Code Live Server or Python / Node / PowerShell)
In PowerShell:
```powershell
# Open directly in default browser:
Start-Process "index.html"
```

---

## 📋 Google Sheets Setup
Follow the complete step-by-step instructions in [`google-apps-script/SETUP_GUIDE.md`](file:///c:/Users/dinam/Documents/ins-inventory/google-apps-script/SETUP_GUIDE.md) to link your Google Sheet.
