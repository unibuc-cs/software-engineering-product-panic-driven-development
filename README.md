# MediaMaster

## Prerequisites
- Get a Supabase URL and Key: https://supabase.com/docs
- Get an IGDB ID and Secret: https://api-docs.igdb.com/#getting-started
- Get a TMDB Access Token: https://developer.themoviedb.org/reference/intro/getting-started
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


## Testing

- Test the services with the CLI app
```bash
rps cli
```

- Test all services with unit tests
```bash
rps test_all
```

- Test individual services with unit tests (replace {service} with igdb, hltb or pcgw)
```bash
rps test_{service}
```
