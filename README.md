# StartTech Application

Full-stack application deployed on AWS using Terraform + GitHub Actions.

- Frontend: React + Vite (S3 + CloudFront)
- Backend: Golang API (EC2 + ALB + Docker)
- Database: MongoDB Atlas

---

## 🚀 Architecture

### Frontend
```text
React → S3 → CloudFront → Users
```

### Backend
```text
React → ALB → EC2 (Docker) → MongoDB Atlas
```

---

## ⚙️ Environment Variables

### Backend
```env
MONGO_URI=
DB_NAME=much_todo_db
PORT=8080
```

### Frontend
```env
VITE_API_URL=
```

---

## 🧪 Local Setup

### Frontend
```bash
cd frontend
npm install
npm run dev
```

### Backend
```bash
cd backend
go run main.go
```

Health check:
```text
/ping
```

---

## 🔄 CI/CD

### Frontend
- Build Vite app
- Upload to S3
- CloudFront invalidation

### Backend
- Build Docker image
- Push to ECR
- Deploy to EC2 via ASG
- Run health checks

Workflows:
```text
.github/workflows/
```

---

## 🐳 Backend Notes

- Runs on port `8080`
- Docker-based deployment
- Requires MongoDB Atlas connection

---

## 🚨 Troubleshooting

### Target group unhealthy
- Check `/ping`
- Ensure container is running
- Confirm port 8080 open

### MongoDB issues
- Verify `MONGO_URI`
- Check Atlas network access

---