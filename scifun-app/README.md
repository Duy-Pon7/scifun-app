# sci_fun

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Web CORS (localhost)

If login works in Postman but fails on Flutter Web with CORS errors, backend must allow your web origin.

For local development, you can run the included proxy:

```bash
dart run tool/cors_proxy.dart
```

Or on Windows PowerShell, run proxy + Flutter web together:

```powershell
powershell -ExecutionPolicy Bypass -File .\tool\run_web_with_proxy.ps1
```

Then set in `.env`:

```env
WEB_BASE_URL = http://192.168.11.61/api/v1
```

`BASE_URL` remains used by mobile/desktop; `WEB_BASE_URL` is used only on web.
