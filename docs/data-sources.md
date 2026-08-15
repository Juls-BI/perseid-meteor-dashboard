# Data sources

## Meteor trajectory data
- **Global Meteor Network**, daily trajectory summary files: https://globalmeteornetwork.org/data/traj_summary_data/daily/
- Public, CC BY 4.0 licensed. Multi-station meteor trajectories, correlated and published daily by GMN's server.
- **Known limitation**: GMN periodically reprocesses already-published daily files as more station observations are correlated in over time. Row counts and any derived stats for a given date (peak hour, sighting count, etc.) can shift between refreshes even for dates published days or weeks earlier. Treat this data as provisional, not a fixed snapshot.
- New nights are typically published a few days after the fact, not same-day.

## Star positions and magnitudes (constellation chart)
- Right ascension, declination, and apparent (V) magnitude for each named star, sourced from individual Wikipedia entries, which in turn draw from SIMBAD (Strasbourg Astronomical Data Center) - see each star's Wikipedia page for full references.
- Example: https://en.wikipedia.org/wiki/Alpha_Persei

## Constellation line figure (which stars connect to which)
- Official IAU stick figure, from Dominic Ford's `star-charter` project: https://github.com/dcf21/star-charter/blob/master/data/constellations/constellation_lines_iau.dat
- Stars in that file are identified by Hipparcos catalogue number; cross-referenced to common Bayer names via https://www.celestialprogramming.com/snippets/CommonStarNames.html
- Two connector stars in the official figure ("b Per" and "c Per", between λ Per and δ Per) don't have individual common names or Wikipedia pages and were not included - λ Per is connected directly to μ Per to δ Per instead as a simplification.

## Country lookup (station code prefixes)
- Manually built from station codes observed in the data; not a strict ISO-3166 mapping, since a couple of GMN country prefixes are informal (e.g. "UK" rather than ISO "GB"). Extend as needed - group `StationSightings` by `CountryCode` to find any prefixes not yet covered.
