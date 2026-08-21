# Perseid Meteor Shower Dashboard

![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?logo=powerbi&logoColor=black)
![Power Query](https://img.shields.io/badge/Power%20Query-M-217346)
![DAX](https://img.shields.io/badge/DAX-measures-217346)
![Deneb](https://img.shields.io/badge/Deneb-Vega--Lite-EB895F)
![Data source](https://img.shields.io/badge/data-Global%20Meteor%20Network-141738)

A Power BI dashboard built around the Perseid meteor shower's 2026 peak, using live data from the Global Meteor Network. Built as a portfolio piece to combine a custom Power Query function, DAX measures, and a from-scratch Deneb (Vega-Lite) visual - not just standard drag-and-drop visuals.

## Preview

![Dashboard preview](assets/PerseidMeteorShower2026.png)

The full working report is `assets/perseid-meteor-dashboard.pbix` - open it directly in Power BI Desktop to explore the visuals, queries, and measures firsthand.

## Opening this in VS Code

The `model/tmdl/` folder is the actual semantic model, exported in TMDL format - open the repo folder directly in VS Code (with the [Power BI extension](https://marketplace.visualstudio.com/items?itemName=PowerBI.vscode-powerbi) or the Fabric/TMDL tooling of your choice) to browse or edit the real model source. The `power-query/` and `dax/` folders hold the same logic as plain `.pq`/`.dax` text files, which are easier to skim on GitHub without needing any tooling at all.

## What's in this repo

- `power-query/` - `fnGetMeteorData` (the custom function pulling live data), `PerseidPeakData`, `StationSightings`, and `CountryLookup` - plain text
- `dax/` - all measures, plain text, with the relationship logic summarised at the top of the file
- `model/tmdl/` - the real exported semantic model (TMDL format)
- `deneb/` - the Vega-Lite spec for the Perseus constellation chart
- `assets/` - dashboard screenshot, background image, and the working `.pbix`
- `docs/` - data source references, and a dedicated write-up of the table relationships and why TREATAS is used ([`relationships-and-treatas.md`](docs/relationships-and-treatas.md))

## How it works

`fnGetMeteorData(EventDate, IAUFilter)` takes a date and an optional IAU shower code (e.g. `"PER"` for Perseids), searches GMN's daily file directory for the matching file (filenames embed a solar-longitude range rather than being purely date-based, so this can't be guessed directly), downloads it, and returns a typed table of that night's meteor trajectories.

`PerseidPeakData` invokes that function across the shower's peak window and adds two derived columns (`InvertedMag`, for sizing map circles so brighter fireballs render bigger; `HourStart`, for grouping by hour). `StationSightings` unpivots the comma-separated list of detecting stations into one row per station per meteor - needed to rank stations and countries by sighting count - and merges in a readable country name via `CountryLookup`.

The two tables relate on `Identifier` (`StationSightings` many-to-one to `PerseidPeakData`, single-direction). Some measures need `TREATAS` to read correctly when filtered by country; others don't. **The full reasoning is in [`docs/relationships-and-treatas.md`](docs/relationships-and-treatas.md)** - worth reading before changing any measure that touches both tables.

The constellation chart is a hand-built Vega-Lite spec rendered through Power BI's Deneb visual - stars as sized points (brighter = bigger), connected by lines matching the official IAU constellation figure.

The geographic map uses Icon Map Pro (a licensed AppSource visual) rather than Deneb, since reliably rendering accurate country outlines inside Power BI's Deneb sandbox wasn't achievable without external map data, which the sandbox blocks.

## Customizing

**Changing the date range** - edit the `Dates` list at the top of `power-query/PerseidPeakData.pq`. Any date GMN hasn't published yet is skipped silently rather than erroring. To pull a different meteor shower entirely, change the `"PER"` IAU code passed into `fnGetMeteorData` (e.g. `"GEM"` for the Geminids) - the function itself doesn't need to change.

**Changing the constellation** - `deneb/perseus-constellation.json` is hand-built for Perseus specifically; there's no dynamic swap. To chart a different constellation, replace the star positions and connecting lines with data for the constellation you want - see `docs/data-sources.md` for where the Perseus data came from; the same two sources cover all 88 constellations.

## Known limitations

- GMN's daily files are provisional and get reprocessed over time - see `docs/data-sources.md`.
- The Icon Map Pro basemap can't be recoloured to exactly match the report's navy/ember palette, since it's provider tile imagery, not something styleable to an arbitrary hex value.
- Two faint connector stars in the official constellation figure don't have individual names and were simplified out - see `docs/data-sources.md`.
- `Top Country` and `Top Country Count` group by two different (but equivalent) fields - see `docs/relationships-and-treatas.md`.

## License

MIT - see `LICENSE`.

## Built

Started as a "couldn't sleep, had to build it" Friday night idea in August 2026, around the actual Perseid peak.
