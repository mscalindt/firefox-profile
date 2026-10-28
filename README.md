![raw_profile_look_before_suggested_config](docs/20261011/look/01.png)

```
20261011 157.0

- docs/20261011/conf (suggested configuration to make after installation)
- scripts/release.sh (source used to build the profile)
  -> chrome/userChrome.css
  -> prefs.js
  -> user.js

Note: On certain machines, this profile and/or its suggested
configuration may result in more frequent captchas and their
subsequent failures.

All distinct configuration files in the profile directory carried over
interactive configuration (not made by release.sh):
- customKeys.json
- prefs.js (cleaned by release.sh)
- shield-preference-experiments.json
- times.json

Peculiar personalized configuration in user.js that might be intrusive
to general usage, safe to remove/adjust:
- browser.cache.disk.enable
- browser.cache.memory.enable
- browser.display.document_color_use
- browser.display.use_document_fonts
- browser.download.dir
- browser.sessionstore.max_tabs_undo
- browser.tabs.groups.enabled
- browser.nova.enabled
- browser.uidensity
- extensions.activeThemeID
- general.smoothScroll
- middlemouse.paste
- mousebutton.4th.enabled
- mousebutton.5th.enabled
- network.protocol-handler.external.mailto
- ui.key.menuAccessKey
- ui.key.menuAccessKeyFocuses
```

Quick download extension links:
- [CanvasBlocker](https://addons.mozilla.org/firefox/downloads/latest/canvasblocker)
- [Get cookies.txt LOCALLY](https://addons.mozilla.org/firefox/downloads/latest/get-cookies-txt-locally)
- [uBlock Origin](https://addons.mozilla.org/firefox/downloads/latest/ublock-origin)
