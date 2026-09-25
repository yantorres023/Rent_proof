# Performance notes

_Measured 2026-09-25 in the Linux cloud container (4 vCPU) using the Dart VM test runner. These are **not device measurements**. Real phones (especially low-end Android) will differ; see VALIDATION_DEBT V-11._

| Scenario | Result | Source |
|---|---|---|
| Import + hash + previews for 60 photos (3000×2000 JPEG) | ~54 s total, ~0.9 s per photo (run in-process in the test; in the app each runs on a background isolate) | report_test "performance" |
| PDF for 60 photos / 12 rooms | ~0.4 s, 2.8 MB | report_test (prints `PERF …`) |
| SHA-256 streaming of a 3 MB file | fast (well under a second); memory is bounded by streaming | media_processing_test |

## Design choices
- Hashing, preview generation, integrity checks and PDF building run in `Isolate.run`, so the UI thread never blocks. Room screens show a progress bar while saving.
- Lists show 360 px thumbnails decoded at display size (`cacheWidth`). Full images are never decoded for lists.
- The PDF embeds ≤1600 px previews (~100–300 KB each for real photos). Expect roughly 15–30 MB for a 100-photo report (estimate, not measured on real photos).
- Photos > 40 MB are stored and hashed but not previewed. Decoding a 48 MP image in pure Dart needs ~150–200 MB of RAM (estimate), so the bound protects low-end devices.

## Practical limits (estimates, to verify on devices)
- 10–15 rooms and 100–200 photos per inspection should be comfortable. The limit is device storage (originals are kept at full size: ~2–6 MB per photo, ~50–200 MB per 2-minute video).
- The evidence package ZIP stores originals uncompressed, so its size ≈ the originals' total size. Sharing very large ZIPs by email will fail; users should save to cloud storage.
