# How to Check Google Places API Key

## Current API Key
Your current API key in `lib/utils/const.dart`:
```
AIzaSyCsHq6nW30klLFbcfuHxYEOV8UinGE6n-0
```

## Method 1: Test in the App (Easiest)
1. Open the profile/account page
2. Look for the "Test API" button next to "Private Information"
3. Tap it - it will test the API key and show a toast message with results
4. Check the console logs for detailed information

## Method 2: Check in Google Cloud Console
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project (likely "insoblokai")
3. Navigate to **APIs & Services** > **Credentials**
4. Find your API key: `AIzaSyCsHq6nW30klLFbcfuHxYEOV8UinGE6n-0`
5. Check:
   - ✅ **API restrictions**: Should include "Places API" (or "Places API (New)")
   - ✅ **Application restrictions**: Should allow your app's package name/bundle ID
   - ✅ **Billing**: Must be enabled for Places API to work

## Method 3: Test API Key Directly via Browser
Test the API key with a direct HTTP request:

**Autocomplete Test:**
```
https://maps.googleapis.com/maps/api/place/autocomplete/json?input=New%20York&key=AIzaSyCsHq6nW30klLFbcfuHxYEOV8UinGE6n-0
```

**Expected Response:**
- ✅ If working: JSON with `predictions` array
- ❌ If error: JSON with `error_message` field

## Method 4: Check API Status
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to **APIs & Services** > **Library**
3. Search for "Places API"
4. Check if it's **ENABLED** (should show "API enabled")
5. If not enabled, click "Enable"

## Common Issues:

### ❌ Error 9011: "This API key is not authorized to use this service or API" ⚠️ **YOUR CURRENT ERROR**
- **Cause**: Places API is NOT ENABLED for your project or API key
- **Fix Steps**:
  1. Go to [Google Cloud Console - APIs Library](https://console.cloud.google.com/apis/library)
  2. Search for **"Places API"** (or "Places API (New)")
  3. Click on it and press **"ENABLE"** button
  4. Wait a few minutes for it to activate
  5. Go to **APIs & Services** > **Credentials**
  6. Click on your API key: `AIzaSyCsHq6nW30klLFbcfuHxYEOV8UinGE6n-0`
  7. Under **"API restrictions"**, make sure **"Places API"** is checked
  8. Click **"Save"**
  9. Test again in the app

### ❌ "PERMISSION_DENIED" or "403"
- **Cause**: API key doesn't have Places API enabled
- **Fix**: Enable Places API in Google Cloud Console (same as above)

### ❌ "REQUEST_DENIED"
- **Cause**: API key restrictions or billing not enabled
- **Fix**: 
  - Check API restrictions include Places API
  - Enable billing for your Google Cloud project
  - Check application restrictions allow your app

### ❌ "INVALID_REQUEST"
- **Cause**: API key format is wrong
- **Fix**: Verify the key in Google Cloud Console matches exactly

### ❌ "No items found" in app
- **Possible causes**:
  1. Places API not enabled (most common - fix above)
  2. CORS proxy service is down (`cors-anywhere.herokuapp.com`)
  3. API key restrictions blocking requests
  4. Network connectivity issues

## Quick Fix Checklist:
- [ ] Places API is enabled in Google Cloud Console
- [ ] API key has Places API in its restrictions
- [ ] Billing is enabled for the project
- [ ] Application restrictions allow your app
- [ ] API key matches exactly in `const.dart`
- [ ] Test API button shows success message

