# MediaMaster

We describe our app in more detail on the Wiki: https://github.com/unibuc-cs/software-engineering-product-panic-driven-development/wiki

## Backend server
- https://mediamaster.fly.dev/

## Usage
- Activate Run Pubspec Script
```bash
dart pub global activate rps
```

- Install the dependencies
```bash
rps restore
```
or
```bash
flutter pub get
```

- Run in debug mode
```bash
rps app:dev
```
or
```bash
flutter run -d windows
```

- Run in release mode
```bash
rps app
```
or
```bash
flutter run -d windows --release
```

## Backend
- Start the server
```bash
rps server
```
or
```bash
dart backend/main.dart
```

- Start the server with hot reload
```bash
rps server:dev
```
or
```bash
dart run --enable-vm-service backend/main.dart
```

- Start the server with nodemon
```bash
rps server:nodemon
```
or
```bash
nodemon -x "dart run backend/main.dart" -e dart
```

## Testing

- Test the services with the CLI app
```bash
rps cli
```

- Test all providers
```bash
rps test:providers
```

- Test all resources
```
rps test:resources
```

- Test individual services with unit tests (replace {service} with igdb, hltb or pcgw)
```bash
rps test:{service}
```
