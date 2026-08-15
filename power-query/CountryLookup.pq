// CountryLookup
// Maps GMN station-code country prefixes (first two letters of a station ID)
// to readable country names. Not a strict ISO-3166 mapping - a couple of GMN
// prefixes are informal (e.g. "UK" rather than the ISO "GB"). Extend this list
// as new station prefixes turn up in your data - check StationSightings
// grouped by CountryCode to find any not yet covered.

let
    Source = #table(
        {"CountryCode", "Country"},
        {
            {"US", "United States"}, {"UK", "United Kingdom"}, {"KR", "South Korea"},
            {"RU", "Russia"}, {"AU", "Australia"}, {"NZ", "New Zealand"},
            {"HR", "Croatia"}, {"IT", "Italy"}, {"BG", "Bulgaria"}, {"GR", "Greece"}
        }
    )
in
    Source
