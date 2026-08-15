// PerseidPeakData
// Invokes fnGetMeteorData across the Perseid peak window (Aug 11-13, 2026),
// typed and with two derived columns (InvertedMag, HourStart) used by the
// Icon Map Pro circle sizing and the rate-over-time chart respectively.
//
// Note: dates that GMN has not yet published a file for are skipped silently
// (try...otherwise) rather than throwing an error - live refreshes will pick
// up newly-published nights automatically without needing this query edited.
//
// Note on data stability: GMN periodically reprocesses already-published daily
// files as more station observations are correlated in. Row counts and derived
// measures (e.g. Peak Hour) for a given date can change between refreshes even
// once that date has "already" been published. Treat GMN data as provisional.

let
    Dates = {#date(2026,8,11), #date(2026,8,12), #date(2026,8,13)},
    DateTable = Table.FromList(Dates, Splitter.SplitByNothing(), {"EventDate"}),
    Invoked = Table.AddColumn(DateTable, "MeteorData", each try fnGetMeteorData([EventDate], "PER") otherwise null),
    RemovedErrors = Table.SelectRows(Invoked, each [MeteorData] <> null),
    RemovedDateCol = Table.RemoveColumns(RemovedErrors,{"EventDate"}),
    Expanded = Table.ExpandTableColumn(RemovedDateCol, "MeteorData", {"Identifier", "JulianDate", "UTCTime", "IAUNo", "IAUCode", "SolLon", "RAgeo", "DECgeo", "Vgeo", "LatBeg", "LonBeg", "HtBeg", "LatEnd", "LonEnd", "HtEnd", "DurationSec", "PeakAbsMag", "PeakHtKm", "MassKg", "Stations"}),
    #"Changed Type" = Table.TransformColumnTypes(Expanded,{
        {"Identifier", type text},
        {"JulianDate", type number},
        {"UTCTime", type datetime},
        {"IAUNo", Int64.Type},
        {"IAUCode", type text},
        {"SolLon", type number},
        {"RAgeo", type number},
        {"DECgeo", type number},
        {"Vgeo", type number},
        {"LatBeg", type number},
        {"LonBeg", type number},
        {"HtBeg", type number},
        {"LatEnd", type number},
        {"LonEnd", type number},
        {"HtEnd", type number},
        {"DurationSec", type number},
        {"PeakAbsMag", type number},
        {"PeakHtKm", type number},
        {"MassKg", type number},
        {"Stations", type text}
    }),
    AddedInvertedMag = Table.AddColumn(#"Changed Type", "InvertedMag", each -[PeakAbsMag], type number),
    AddedHourStart = Table.AddColumn(AddedInvertedMag, "HourStart", each DateTime.From(Date.From([UTCTime])) + #duration(0, Time.Hour([UTCTime]), 0, 0), type datetime)
in
    AddedHourStart
