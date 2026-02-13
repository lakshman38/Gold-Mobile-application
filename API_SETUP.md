# API Configuration Guide

## OpenAI API Setup (for Chatbot)

### Step 1: Get OpenAI API Key

1. Go to [OpenAI Platform](https://platform.openai.com)
2. Sign up or log in
3. Navigate to API Keys section
4. Click "Create new secret key"
5. Copy your API key

### Step 2: Configure in App

1. Open `lib/services/chatbot_service.dart`
2. Replace `YOUR_OPENAI_API_KEY` with your actual API key:

```dart
_openAI = OpenAI.instance.build(
  token: 'sk-your-actual-api-key-here',
  baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 30)),
  enableLog: true,
);
```

### Step 3: Test Chatbot

Run the app and click the chatbot button to test:
- Ask "What is today's gold rate?"
- Ask "Show customer balance"

## Gold & Silver Rate API Setup

### Option 1: Metal Price API (Recommended)

1. Go to [Metal Price API](https://metalpriceapi.com)
2. Sign up for a free account
3. Get your API key
4. Update `lib/services/gold_rate_service.dart`:

```dart
final response = await http.get(
  Uri.parse('https://api.metalpriceapi.com/v1/latest?api_key=YOUR_API_KEY&base=INR&currencies=XAU,XAG'),
);
```

### Option 2: Use Mock Rates

If you don't have an API key, the app will use default mock rates:
- Gold: ₹6000 per gram
- Silver: ₹70 per gram

You can update these in `lib/services/gold_rate_service.dart`

### Option 3: Manual Rate Updates

Store rates manually in Firestore:

1. Go to Firebase Console → Firestore
2. Create a document in `rates` collection with ID `latest`
3. Add fields:
   - `goldRate`: 6000
   - `silverRate`: 70
   - `timestamp`: current ISO8601 string
   - `currency`: "INR"

## Security Best Practices

### Use Environment Variables

For production, use environment variables:

1. Create `.env` file in root:
```
OPENAI_API_KEY=your-openai-key
METAL_API_KEY=your-metal-api-key
```

2. Add to `.gitignore`:
```
.env
```

3. Use `flutter_dotenv` package to load keys

### Secure API Keys

- Never commit API keys to version control
- Use Firebase Remote Config for dynamic keys
- Implement API key rotation
- Monitor API usage

## Rate Limiting

- OpenAI: Free tier has rate limits
- Metal Price API: Check your plan's limits
- Implement caching to reduce API calls
- Store rates in Firestore for offline access

## Troubleshooting

### OpenAI Issues
- **401 Unauthorized**: Check API key is correct
- **429 Too Many Requests**: You've hit rate limit
- **Timeout**: Increase timeout duration

### Rate API Issues
- **Connection failed**: Check internet connection
- **Invalid response**: Verify API endpoint and format
- **Rate limit**: Reduce frequency of API calls

## Alternative APIs

If you prefer different APIs:

### Gold API
- https://www.goldapi.io
- https://www.fcsapi.com

### Forex API
- https://exchangerate-api.com
- https://currencyapi.com

Update the service files accordingly based on the API you choose.
