# Windows console color schemes

Solarized registry assets intended for the classic Windows Console host.

## Registry palettes

- [`solarized-dark.reg`](solarized-dark.reg) is a valid Solarized Dark registry
	palette.
- [`solarized-light.reg`](solarized-light.reg) is not usable; despite its
	extension, it currently contains saved GitHub HTML.

Importing a `.reg` file modifies `HKEY_CURRENT_USER\Console`. Review the file
before applying it, close active console windows, then double-click the chosen
file or import it from an ordinary Command Prompt:

```bat
reg import solarized-dark.reg
```

Registry changes affect the current Windows user. Export
`HKEY_CURRENT_USER\Console` first if the existing palette must be recoverable.
Windows Terminal manages color schemes in its own settings and does not use
these registry values.

## PowerShell scripts

Do not run these files in their current state:

- [`Set-SolarizedDarkColorDefaults.ps1`](Set-SolarizedDarkColorDefaults.ps1)
- [`Set-SolarizedLightColorDefaults.ps1`](Set-SolarizedLightColorDefaults.ps1)

Despite their extensions, both currently contain saved GitHub HTML rather than
PowerShell source. They are retained for investigation but are not valid theme
installers. Use `solarized-dark.reg` for the classic Console host; a valid light
palette must be restored before light-theme installation can be documented.

There is no Makefile target for this directory; setup is intentionally manual
and Windows-specific.
