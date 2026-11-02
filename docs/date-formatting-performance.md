# Date formatting performance

Style-based output through `CalendarUtilImpl.string(for:dateStyle:timeStyle:)`
reuses `DateFormatter` instances. CSV exporters commonly request full date and
time styles; result rows commonly request medium dates and short times. This
avoids constructing a formatter for every field or visible row.

The cache retains at most 25 formatters: the five date styles crossed with the
five time styles for one set of locale, calendar, and default time-zone settings.
Preference changes clear the previous entries. Locale/time-zone notifications
also invalidate them. Creation happens outside the cache lock, and a generation
check discards a formatter if invalidation occurs during its construction.
Published formatters are never reconfigured, and observer closures hold the
cache weakly.

Parsing retains its existing fresh-formatter implementation. A macOS measurement
found reuse improved formatting but slowed parsing, so this optimization applies
only to output. Custom-format output through SwiftDate is also unchanged. No
stored timestamps or date-picker precision rules change.

## Reproducing the measurement

On a Mac with Xcode command-line tools:

```sh
python3 scripts/benchmark-date-formatting.py --iterations 2000
```

The script compiles the actual production cache with Foundation in Swift 5 mode
and an optimized executable. It checks every style pair against a fresh formatter,
parse compatibility, reuse, default time-zone changes, notification invalidation,
and concurrent reads before timing three rounds of each real caller's style pair.
Timing ratios are informational and never determine pass/fail. Each timed round
uses the same dates and verifies matching output-length checksums; exact output
comparisons run separately before measurement.

On the Intel macOS 15 runner in
[run 41484299298](https://github.com/TimeDelta/introspective/actions/runs/41484299298),
2,000 calls per round produced these results:

| Style and caller | Fresh formatter, range | Cached formatter, range | Median of the three speedup ratios |
| --- | --- | --- | --- |
| Full/full, CSV | 178–187 ms | 15–37 ms | 11.3× |
| Medium/short, result row | 194–379 ms | 19–29 ms | 10.2× |
| None/short, time display | 121–158 ms | 13–15 ms | 9.4× |

These are formatter measurements on a macOS runner, not end-to-end iPhone export
or scrolling measurements. Full iOS CI remains required for integration validation.
Six native regressions additionally exercise compatibility across dates, all 25
style pairs, observer lifetime, default time-zone changes, mixed concurrent calls,
and invalidation while an older formatter is still being constructed.
