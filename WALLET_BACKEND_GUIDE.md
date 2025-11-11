# Wallet Backend Server Configuration Guide

## 📍 Where the Wallet Backend URL is Configured

The wallet backend server URL is defined in:
**`lib/utils/const.dart`** (Line 68)

```dart
const INSOBLOK_WALLET_URL = "https://insoblok-wallet-backend.ue.r.appspot.com";
```

## 🔗 Where It's Used

The `INSOBLOK_WALLET_URL` is used in the following files:

1. **`lib/providers/profiles/wallet_send_provider.dart`** (Line 155)
   ```dart
   final api = ApiService(baseUrl: INSOBLOK_WALLET_URL);
   ```

2. **`lib/services/web3_service.dart`** (Line 26)
   ```dart
   final api = ApiService(baseUrl: INSOBLOK_WALLET_URL);
   ```

3. **`lib/services/crypto_service.dart`** (Line 107)
   ```dart
   final apiService = ApiService(baseUrl: INSOBLOK_WALLET_URL);
   ```

## 🔍 How to Check/Verify the Server

### 1. **Check Server Status via Browser**
Open the following URL in your browser:
```
https://insoblok-wallet-backend.ue.r.appspot.com
```

If the server is running, you should see a response (even if it's an error page, it means the server is reachable).

### 2. **Test API Endpoints**

The main endpoint used for sending tokens is:
```
POST https://insoblok-wallet-backend.ue.r.appspot.com/evm/send
```

You can test this using:
- **Postman**
- **curl** command
- **Browser DevTools** (Network tab)

### 3. **Add Logging to Debug Server Issues**

To see what's being sent to the server, you can add logging in `lib/services/api_service.dart`:

```dart
Future<dynamic> postRequest(String endpoint, Map<String, dynamic> body) async {
  final url = Uri.parse('$baseUrl$endpoint');
  
  // Add logging
  logger.d("POST Request to: $url");
  logger.d("Request Body: ${jsonEncode(body)}");

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    // Add response logging
    logger.d("Response Status: ${response.statusCode}");
    logger.d("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('POST failed: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    logger.e("POST Exception: $e");
    throw Exception('POST Exception: $e');
  }
}
```

### 4. **Check Server Logs (if you have access)**

If you have access to the Google Cloud Platform console:
1. Go to Google Cloud Console
2. Navigate to App Engine → Services
3. Find `insoblok-wallet-backend`
4. Check the logs for errors

### 5. **Test with curl Command**

Test the server endpoint directly:

```bash
curl -X POST https://insoblok-wallet-backend.ue.r.appspot.com/evm/send \
  -H "Content-Type: application/json" \
  -d '{
    "chain": "ethereum",
    "chainId": 1,
    "signed_raw_tx": "0x...",
    "from_address": "0x...",
    "to_address": "0x...",
    "token_address": "",
    "token_symbol": "ETH",
    "amount": "0.1",
    "decimals": "18",
    "is_native_token": "true"
  }'
```

## 🐛 Common Issues and Solutions

### Issue: "Failed to send token due to internal server error"

**Possible Causes:**
1. **Server is down or unreachable**
   - Check if the URL is accessible
   - Verify the server is running

2. **Invalid request format**
   - Check the request body structure
   - Verify all required fields are present

3. **Network issues**
   - Check internet connection
   - Verify firewall/proxy settings

4. **Server-side errors**
   - Check server logs
   - Verify server configuration

### How to Debug:

1. **Enable detailed logging** (as shown above)
2. **Check the Flutter console** for error messages
3. **Use Network Inspector** in Flutter DevTools
4. **Test the endpoint directly** with curl or Postman

## 📝 API Endpoints Used

Based on the code, the following endpoints are used:

1. **`/evm/send`** - Send EVM tokens
   - Used in: `web3_service.dart` → `sendEvmToken()`
   - Method: POST
   - Body includes: chain, chainId, signed_raw_tx, from_address, to_address, etc.

2. **Other endpoints** may be used in:
   - `crypto_service.dart` - For wallet operations
   - `web3_service.dart` - For transaction fees, balances, etc.

## 🔧 How to Change the Server URL

To change the wallet backend URL:

1. **Edit `lib/utils/const.dart`** (Line 68)
   ```dart
   const INSOBLOK_WALLET_URL = "https://your-new-server-url.com";
   ```

2. **Restart the app** to apply changes

3. **For different environments** (dev/staging/prod), consider using:
   ```dart
   const INSOBLOK_WALLET_URL = String.fromEnvironment(
     'WALLET_BACKEND_URL',
     defaultValue: 'https://insoblok-wallet-backend.ue.r.appspot.com',
   );
   ```

   Then run with:
   ```bash
   flutter run --dart-define=WALLET_BACKEND_URL=https://your-dev-server.com
   ```

## 📊 Monitoring Server Health

To monitor the server health, you can:

1. **Add a health check endpoint** in your app
2. **Periodically ping the server** to check availability
3. **Log server response times** to detect performance issues
4. **Set up alerts** for server downtime

## 🔐 Security Notes

- The server URL is currently hardcoded in the app
- Consider using environment variables for production
- Ensure HTTPS is used (which it is: `https://`)
- Validate server certificates in production

