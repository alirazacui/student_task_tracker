# Deployment Guide

## Deploying Backend to Render.com

1. **Create a Render.com Account**
   - Go to [render.com](https://render.com)
   - Sign up for a free account

2. **Prepare Your Backend**
   - Make sure your backend code is in a GitHub repository
   - Ensure you have a `.env` file with your environment variables:
     ```
     MONGO_URI=your_mongodb_connection_string
     JWT_SECRET=your_jwt_secret
     PORT=5000
     ```

3. **Deploy to Render**
   - In Render dashboard, click "New +" and select "Web Service"
   - Connect your GitHub repository
   - Configure the service:
     - Name: `student-task-tracker-api` (or your preferred name)
     - Environment: `Node`
     - Build Command: `npm install`
     - Start Command: `npm start`
   - Add your environment variables from your `.env` file
   - Click "Create Web Service"

4. **Update Flutter App**
   - Once deployed, Render will give you a URL like `https://your-app-name.onrender.com`
   - Open `teacher_app/lib/services/api_service.dart`
   - Set `_isProduction = true`
   - Replace `your-app-name` in `_prodBaseUrl` with your actual Render app name
   - Build and distribute your Flutter app

## Building Flutter App for Distribution

1. **Android App Bundle (Recommended)**
   ```bash
   flutter build appbundle
   ```
   The app bundle will be in `build/app/outputs/bundle/release/app-release.aab`

2. **APK (Alternative)**
   ```bash
   flutter build apk
   ```
   The APK will be in `build/app/outputs/flutter-apk/app-release.apk`

## Sharing the App

1. **For Android:**
   - Share the APK file directly
   - Or upload to Google Play Store (requires developer account)

2. **For iOS:**
   - Requires Apple Developer account
   - Upload to App Store Connect
   - Share via TestFlight

## Important Notes

1. **Security:**
   - Keep your JWT_SECRET secure
   - Use HTTPS in production
   - Implement proper error handling

2. **Database:**
   - Use MongoDB Atlas for cloud database
   - Keep your connection string secure

3. **Updates:**
   - When updating the backend, push to GitHub
   - Render will automatically redeploy
   - Update the app version when making significant changes

## Troubleshooting

1. **Backend Issues:**
   - Check Render logs
   - Verify environment variables
   - Test API endpoints using Postman

2. **App Issues:**
   - Clear app data/cache
   - Check internet connection
   - Verify API URL in app 