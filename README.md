# Jobzshala — Job Matches

A Flutter application built for the Jobzshala GCC take-home assignment.

The app helps Indian workers explore job opportunities in the UAE, Saudi Arabia, and Qatar. It includes a paginated job feed, job details, an application flow, English and Hindi localization, and offline support.

The project uses a mock API, so it can be run and tested without a backend.

## Features

### Job Matches

- Displays job title, employer, location, salary range, match score, and skills.
- Sorts jobs by match score, highest first.
- Filters jobs by country.
- Supports pull-to-refresh and paginated loading.
- Includes loading, empty, and error states.
- Displays application status on job cards.

### Job Details

- Shows the job description, requirements, and match reason.
- Displays accommodation, food, and visa benefits.
- Keeps the Apply button accessible at the bottom of the screen.
- Prevents applications while offline.

### Application Flow

- Updates the interface immediately when an application is submitted.
- Simulates network delays and server errors.
- Rolls back the optimistic update if the request fails.
- Displays a confirmation with an application reference on success.
- Persists successful applications across app restarts.

### Offline Support

- Caches job data locally.
- Displays saved jobs when the network is unavailable.
- Shows an offline banner and disables the Apply action.
- Supports switching between online and offline modes for testing.

### Localization

- Supports English and Hindi.
- Updates UI labels and messages without restarting the app.
- Keeps API-provided job descriptions in English.

## Tech Stack

| Technology | Purpose |
|---|---|
| Flutter and Dart | Android application |
| Provider | Application state management |
| SharedPreferences | Local persistence and cached data |
| Google Fonts | Typography |
| intl | Number and date formatting |
| flutter_lints | Static analysis |

The implementation uses custom Flutter widgets rather than a large UI component library.

## Project Structure

The code is organized by feature, with shared infrastructure kept separate.

```text
lib/
├── app/
│   ├── app.dart
│   └── theme/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── localization/
│   ├── network/
│   └── storage/
├── features/
│   ├── job_matches/
│   │   ├── data/
│   │   └── presentation/
│   ├── job_details/
│   │   └── presentation/
│   └── job_application/
│       └── presentation/
├── shared/
│   └── widgets/
└── main.dart

test/