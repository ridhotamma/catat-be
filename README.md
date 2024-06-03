---

# 🐾 **Catat - Open Source Attendance System Restful API**

![Catat Banner](https://via.placeholder.com/1200x300?text=Catat+-+Open+Source+Attendance+System)

## 🚀 **Description:**
Catat is an open-source attendance system designed to streamline the process of tracking employee attendance, leave requests, sick days, and more. With an intuitive and user-friendly interface, Catat simplifies attendance management for organizations of all sizes.

---

## 🎯 **Features:**

### 🏢 **Organization Management**
- Easily manage multiple organizations within the system.
- Organize departments and teams for better structure.
- View comprehensive reports and analytics for each organization.

### 👥 **Employee/Student Management**
- Add, edit, and remove employee/student information with ease.
- Track attendance, leave, and performance for every individual.
- Manage profiles and personal information securely.

### 🕒 **Clock In and Clock Out Attendance**
- Seamless clock in/out system with accurate time tracking.
- Mobile-friendly interface for on-the-go attendance marking.
- Real-time attendance data available for admins.

### ⚙️ **Attendance Settings**
- Configure attendance radius to prevent false check-ins.
- Set up auto-approval for specific scenarios or roles.
- Customize attendance rules to fit organizational policies.

### 🔐 **Authorization Based on Role**
- Define user roles with specific permissions and access levels.
- Secure data access to ensure only authorized personnel can view/edit information.
- Flexible role management to accommodate organizational changes.

---

## 📦 **Installation:**

### **Using Docker (Recommended):**

1. **Clone the Repository:**
    ```bash
    git clone https://github.com/ridhotamma/catat-be.git
    ```

2. **Navigate to the Project Directory:**
    ```bash
    cd catat-be
    ```

3. **Build and Run the Docker Containers:**
    ```bash
    docker-compose up --build
    ```

4. **Set Up the Database:**
    ```bash
    docker-compose run web rake db:create db:migrate db:seed
    ```

5. **Access the Application:**
    - Open your browser and navigate to `http://localhost:3000`

### **Manual Setup:**

1. **Clone the Repository:**
    ```bash
    git clone https://github.com/ridhotamma/catat-be.git
    ```

2. **Navigate to the Project Directory:**
    ```bash
    cd catat-be
    ```

3. **Install Dependencies:**
    ```bash
    bundle install
    ```

4. **Set Up the Database:**
    ```bash
    rails db:create db:migrate db:seed
    ```

5. **Run the Application:**
    ```bash
    rails server
    ```

6. **Access the Application:**
    - Open your browser and navigate to `http://localhost:3000`
