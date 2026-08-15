// StationSightings
// Unpivots the comma-separated Stations field on PerseidPeakData into one row
// per station per meteor, plus a CountryCode derived from the first two
// characters of each station code. Relates back to PerseidPeakData on
// Identifier (one-to-many: PerseidPeakData is the "1" side).

let
    Source = PerseidPeakData,
    AddedStationList = Table.AddColumn(Source, "StationList", each Text.Split([Stations], ",")),
    ExpandedStations = Table.ExpandListColumn(AddedStationList, "StationList"),
    RenamedStation = Table.RenameColumns(ExpandedStations, {{"StationList", "Station"}}),
    TrimmedStation = Table.TransformColumns(RenamedStation, {{"Station", Text.Trim, type text}}),
    #"Removed Other Columns" = Table.SelectColumns(TrimmedStation,{"Identifier", "Station"}),
    ChangedType = Table.TransformColumnTypes(#"Removed Other Columns", {{"Station", type text}}),
    AddedCountryCode = Table.AddColumn(ChangedType, "CountryCode", each Text.Start([Station], 2), type text)
in
    AddedCountryCode
