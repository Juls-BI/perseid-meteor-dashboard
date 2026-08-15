// fnGetMeteorData
// Pulls a single day's meteor trajectory summary from the Global Meteor Network
// (globalmeteornetwork.org), filtered optionally to one IAU shower code (e.g. "PER").
// Live fetch - searches the daily directory listing for the file matching EventDate,
// since filenames embed a solar-longitude range that is not fixed to a calendar date.

(EventDate as date, optional IAUFilter as text) as table =>
let
    DateText = Date.ToText(EventDate, "yyyyMMdd"),
    DirUrl = "https://globalmeteornetwork.org/data/traj_summary_data/daily/",
    DirSource = Web.Contents(DirUrl),
    Links = Html.Table(DirSource, {{"Href", "a", each [Attributes][href]?}}),
    Matched = Table.SelectRows(Links, each Text.StartsWith([Href], "traj_summary_" & DateText)),
    FileName = Matched{0}[Href],
    FileUrl = DirUrl & FileName,

    RawText = Text.FromBinary(Web.Contents(FileUrl)),
    Lines = Lines.FromText(RawText),
    DataLines = List.Select(Lines, each not Text.StartsWith(Text.Trim(_), "#") and Text.Trim(_) <> ""),
    Split = List.Transform(DataLines, each Text.Split(_, ";")),
    ToTable = Table.FromRows(Split),

    // Column positions confirmed against the raw file header (see docs/data-source-notes.md)
    Renamed = Table.RenameColumns(ToTable, {
        {"Column1", "Identifier"}, {"Column2", "JulianDate"}, {"Column3", "UTCTime"},
        {"Column4", "IAUNo"}, {"Column5", "IAUCode"}, {"Column6", "SolLon"},
        {"Column8", "RAgeo"}, {"Column10", "DECgeo"}, {"Column16", "Vgeo"},
        {"Column64", "LatBeg"}, {"Column66", "LonBeg"}, {"Column68", "HtBeg"},
        {"Column70", "LatEnd"}, {"Column72", "LonEnd"}, {"Column74", "HtEnd"},
        {"Column76", "DurationSec"}, {"Column77", "PeakAbsMag"}, {"Column78", "PeakHtKm"},
        {"Column80", "MassKg"}, {"Column86", "Stations"}
    }, MissingField.Ignore),

    Trimmed = Table.TransformColumns(Renamed, {
        {"IAUCode", Text.Trim, type text},
        {"UTCTime", Text.Trim, type text},
        {"Stations", Text.Trim, type text}
    }),

    Filtered = if IAUFilter = null then Trimmed
               else Table.SelectRows(Trimmed, each [IAUCode] = IAUFilter)
in
    Filtered
