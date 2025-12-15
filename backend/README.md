# Glamora Backend API

## 🚀 Quick Start for Buyer

This is a **production-ready** Node.js backend for the Glamora beauty booking platform. Everything is coded and ready - you just need to add your API keys and deploy!

### ⏱️ Setup Time: **15-20 minutes**

---

## 💰 Cost Breakdown (Buyer Responsibility)

| Service | FREE Tier | Paid Tier | Required? |
|---------|-----------|-----------|-----------|
| **Backend Hosting** (Render.com) | ✅ FREE | $7/month | ✅ Yes |
| **Database** (Supabase PostgreSQL) | ✅ 500MB FREE | $25/month | ✅ Yes |
| **Storage** (Cloudinary) | ✅ 25GB FREE | $99/month | ✅ Yes |
| **Email** (SendGrid) | ✅ 100/day FREE | $15/month | Optional |
| **Payment** (Stripe) | 2.9% + $0.30/txn | Same | Optional |
| **TOTAL** | **$0/month** | **$146/month** | **Start FREE!** |

---

## 📋 Step-by-Step Deployment

### Step 1: Create Free Accounts (5 minutes)

1. **Database - Supabase** (FREE 500MB)
   - Go to: https://supabase.com
   - Click "Start your project"
   - Create new project
   - Copy `DATABASE_URL` from Settings > Database

2. **Hosting - Render.com** (FREE tier)
   - Go to: https://render.com
   - Sign up with GitHub
   - Ready for Step 3

3. **Storage - Cloudinary** (FREE 25GB)
   - Go to: https://cloudinary.com
   - Sign up
   - Copy Cloud Name, API Key, API Secret

### Step 2: Configure Environment (5 minutes)

1. Copy `.env.example` to `.env`
2. Fill in the values you got from Step 1
3. Generate JWT secret:
   ```bash
   node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
   ```

### Step 3: Deploy to Render (5 minutes)

1. Push code to GitHub (if not already)
2. Go to Render Dashboard
3. Click "New +" → "Web Service"
4. Connect your GitHub repo
5. Configure:
   - **Name:** glamora-backend
   - **Build Command:** `npm install`
   - **Start Command:** `npm start`
6. Add Environment Variables (from your `.env`)
7. Click "Create Web Service"
8. **DONE!** Backend is LIVE! 🎉

### Step 4: Test Backend (2 minutes)

Visit: `https://your-app.onrender.com/health`

You should see:
```json
{
  "status": "healthy",
  "timestamp": "2024-12-15T00:00:00.000Z",
  "version": "1.0.0"
}
```

✅ **Backend is working!**

---

## 🔌 API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login with Firebase token
- `GET /api/auth/me` - Get current user

### Users
- `GET /api/users` - List all users (admin only)
- `GET /api/users/:id` - Get user by ID
- `PUT /api/users/:id` - Update user
- `DELETE /api/users/:id` - Delete user (admin only)

### Providers
- `GET /api/providers` - List all providers
- `POST /api/providers` - Create provider
- `GET /api/providers/:id` - Get provider details
- `PUT /api/providers/:id` - Update provider
- `PUT /api/providers/:id/approve` - Approve provider (admin only)

### Bookings
- `POST /api/bookings` - Create booking
- `GET /api/bookings` - List bookings
- `GET /api/bookings/:id` - Get booking details
- `PUT /api/bookings/:id/status` - Update booking status
- `DELETE /api/bookings/:id` - Cancel booking

### Payments
- `POST /api/payments/create-intent` - Create payment intent
- `POST /api/payments/confirm` - Confirm payment
- `GET /api/payments/:id` - Get payment status

### Reviews
- `POST /api/reviews` - Create review
- `GET /api/reviews/provider/:id` - Get provider reviews
- `PUT /api/reviews/:id` - Update review
- `DELETE /api/reviews/:id` - Delete review

### Admin
- `GET /api/admin/stats` - Dashboard statistics
- `GET /api/admin/users` - All users with filters
- `PUT /api/admin/users/:id/block` - Block/unblock user
- `GET /api/admin/revenue` - Revenue analytics

---

## 🛠️ Local Development (Optional)

```bash
# Install dependencies
npm install

# Create .env file
cp .env.example .env
# Edit .env with your credentials

# Run database migrations
npm run migrate

# Start development server
npm run dev

# Server runs on http://localhost:3000
```

---

## 📦 What's Included

✅ **Complete REST API** - All endpoints for full app functionality
✅ **Authentication** - Firebase Admin SDK integration
✅ **Database Models** - PostgreSQL with Sequelize ORM
✅ **Security** - Helmet, CORS, JWT validation
✅ **Error Handling** - Proper HTTP status codes
✅ **Logging** - Morgan request logging
✅ **Validation** - Input validation on all endpoints
✅ **Payment** - Stripe integration ready
✅ **File Upload** - Cloudinary integration
✅ **Email** - Notification system ready

---

## 🔐 Security Features

- ✅ Firebase Authentication
- ✅ JWT token validation
- ✅ Role-based access control (Customer, Provider, Admin)
- ✅ Input sanitization
- ✅ SQL injection protection
- ✅ XSS protection (Helmet)
- ✅ CORS configured
- ✅ Rate limiting ready

---

## 📊 Database Schema

### Users Table
- id, firebaseUid, email, name, phone
- role (customer/provider/admin)
- status, totalBookings, totalSpent

### Providers Table
- businessName, type, address, city
- lat/long, services, specialties
- rating, status, revenue

### Bookings Table
- bookingNumber, userId, providerId
- service, date, time, status
- amount, commission, paymentStatus

### Reviews, Payments, Staff (all included)

---

## 🚨 Troubleshooting

**Database connection failed?**
- Check DATABASE_URL format
- Ensure Supabase project is active
- Verify IP whitelist (allow all: 0.0.0.0/0)

**Backend not starting?**
- Check all required env variables
- Run `npm install` again
- Check Render logs

**API returns 401?**
- Verify Firebase credentials
- Check JWT_SECRET is set
- Ensure token is sent in header

---

## 💡 Next Steps After Deployment

1. ✅ Update Flutter app with backend URL
2. ✅ Test all API endpoints
3. ✅ Configure Stripe for payments
4. ✅ Set up email notifications
5. ✅ Add custom domain (optional)
6. ✅ Enable SSL (automatic on Render)

---

## 📞 Support

- **Documentation:** See `/docs` folder
- **API Testing:** Use Postman collection (included)
- **Issues:** Check troubleshooting guide

---

## 🎉 That's It!

Your backend is ready to handle **thousands of users**. Just deploy and go!

**Total Setup Time:** 15-20 minutes
**Monthly Cost:** $0 (FREE tier) to $7 (if you exceed free limits)

---

*Built with ❤️ for easy deployment and scalability*
