# PrestatieDash
Dashboard om huidige statistieken mee weer te geven

## Hoe het werkt
`omzet-tracker.html` is een losse pagina, gewoon openen in een browser (bv. op een scherm in de winkel). Hij haalt de omzet per land (NL/DE/BE/FR) op via een Make.com webhook (`SUMMARY_URL` in de script).

- Ververst elk uur, alleen tijdens openingstijd (ma-za 9:00-17:00, zo dicht). Bij opening wordt direct ververst.
- Buiten openingstijd staat er "Buiten openingstijd" en wordt er niks opgehaald.
- Toets `1` = omzet per land, toets `2` = grafieken voor Nederland (maand, jaar, saunas, hottubs; `#2` achter de URL opent ze direct). De grafieken gebruiken nog dummy data uit `getChartData()` in de script.
- Status-dot: groen = data is vers, rood = laatste geslaagde refresh is ouder dan een uur (of mislukt), geel = gesloten.

Tijden en interval aanpassen: `OPEN_HOUR`, `CLOSE_HOUR`, `REFRESH_MS` en `STALE_AFTER_MS` bovenin het script.
