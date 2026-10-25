# Course Explorer v2

Aplikasi Flutter yang menerapkan **State Management** dengan **Provider** dan **Mobile Application Architecture** berlapis.

| | |
|---|---|
| **Nama** | Desy_Putri |
| **NIM** | 2415051002 |
| **Mata Kuliah** | Pemrograman Mobile |
| **Pertemuan** | 6 — State Management & Mobile Application Architecture |
| **Dosen** | Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom |
| **TA** | Made Yuda Sadewa, S.Pd. |

---

## Arsitektur Aplikasi

Aplikasi ini menerapkan **separation of concerns** dengan arah dependency:
Screen/Widget → Provider → Repository → Service → JSON



- **UI tidak tahu** dari mana data berasal (JSON, API, DB).
- **Provider tidak tahu** apakah data dari JSON atau API.
- **Service** menangani detail teknis sumber data.
- **Repository** menjadi abstraksi antara Service dan Provider.

---

## Struktur Folder
lib/
├── main.dart
├── data/
│ └── student_constants.dart
├── models/
│ └── course.dart
├── providers/
│ └── course_provider.dart
├── repositories/
│ └── course_repository.dart
├── services/
│ └── course_service.dart
├── screens/
│ ├── adaptive_shell.dart
│ ├── home_page.dart
│ ├── courses_page.dart
│ ├── course_detail_page.dart
│ ├── favorites_page.dart
│ └── feedback_page.dart
└── widgets/
├── course_card.dart
├── info_row.dart
└── home_menu_tile.dart



---

## Tanggung Jawab Setiap Folder

| Folder | Tanggung Jawab |
|---|---|
| **data/** | Konstanta global (NIM, Nama mahasiswa). |
| **models/** | Representasi data — parsing JSON ke object Dart. |
| **services/** | Detail teknis sumber data — baca file JSON dari assets. |
| **repositories/** | Abstraksi sumber data untuk Provider. |
| **providers/** | State management — loading, error, data, favorites. |
| **screens/** | Halaman UI — navigation, layout, responsive. |
| **widgets/** | Widget reusable — CourseCard, InfoRow, HomeMenuTile. |

---

## Arah Dependency
Screens/Widgets
│
▼
Providers
│
▼
Repositories
│
▼
Services
│
▼
JSON / API / DB

text

**Aturan:**
- UI hanya akses Provider.
- Provider hanya akses Repository.
- Repository hanya akses Service.
- UI **tidak boleh** akses `rootBundle`/`jsonDecode` langsung.
- Service **tidak boleh** mengandung Widget/UI.
- Provider **tidak boleh** menyimpan `BuildContext`.

---

## Fitur

- Responsive layout (compact / medium / expanded).
- Adaptive navigation (NavigationBar ↔ NavigationRail).
- Async data loading dari JSON statik.
- Loading, error, dan success state.
- Favorites shared state (konsisten di 3 screen).
- Search & filter course.
- Form feedback dengan validasi.
- SnackBar, Dialog, loading overlay.
- State management dengan ChangeNotifier + Provider.
- Model, Service, Repository, Provider terpisah.

---

## Alur Data
CourseProvider
│ repository.getCourses()
▼
CourseRepository
│ service.loadCourses()
▼
CourseService
│ rootBundle.loadString + jsonDecode
▼
students_data.json

text

---

## Cara Menjalankan

1. **Persiapan:**

   ```bash
   flutter pub get
Jalankan di Chrome:

bash
flutter run -d chrome
Jalankan di emulator Android:

bash
flutter run
Catatan
Data course berasal dari assets/data/students_data.json.

Sumber data dapat diganti ke REST API tanpa mengubah Provider — cukup ubah CourseService.

Struktur folder mengikuti prinsip separation of concerns.

Setiap layer hanya tahu layer di bawahnya (dependency direction satu arah).

© 2026 — Desy_Putri | 2415051002
## REST API Endpoint

Berikut endpoint REST yang digunakan untuk integrasi aplikasi Flutter dengan backend.

| Properti | Nilai |
|---|---|
| **Base URL** | `https://course-api-pearl.vercel.app` |
| **Endpoint** | `/courses` |
| **Method** | `GET` (Read), `POST` (Create), `PUT/PATCH` (Update), `DELETE` (Delete) |
| **Status Code (GET)** | `200 OK` |
| **Field JSON** | `id` (int), `code` (String), `title` (String), `credits` (int), `status` (String), `created_at` (String/timestamp) |

**Contoh Response (GET /courses):**

```json
[
  {
    "id": 2,
    "code": "MOB02",
    "title": "Dart Fundamentals",
    "credits": 3,
    "status": "active",
    "created_at": "2026-10-21T03:28:09.128977Z"
  },
  {
    "id": 3,
    "code": "MOB03",
    "title": "Flutter Widgets & Layout",
    "credits": 3,
    "status": "planned",
    "created_at": "2026-10-21T03:28:09.361747Z"
  }
]
---

## Database Schema

**Tabel:** `courses` (Supabase/PostgreSQL)

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | bigint, primary key | Auto-increment |
| `code` | text, unique, not null | Kode MK |
| `title` | text, not null | Judul course |
| `credits` | int, default 1 | Jumlah SKS |
| `status` | text, check | `planned`/`active`/`done` |
| `created_at` | timestamptz | Timestamp otomatis |

**RLS Policy:** `Allow all for praktikum` (hanya untuk praktikum, bukan produksi).