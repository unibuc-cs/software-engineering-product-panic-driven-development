# MediaMaster

We describe our app in more detail on the Wiki: https://github.com/unibuc-cs/software-engineering-product-panic-driven-development/wiki . 

## Prerequisites
- Get a Supabase URL and Key: https://supabase.com/docs
- Get an IGDB ID and Secret: https://api-docs.igdb.com/#getting-started
- Add them into .env.example and remove .example from the name

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
rps dev
```
or
```bash
flutter run -d windows
```

- Run in release mode
```bash
rps run
```
or 
```bash
flutter run -d windows --release
```
