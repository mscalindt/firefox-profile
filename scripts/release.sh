# Create a new profile using any Firefox instance and run this script on it:
# -> create the profile
# -> run the script on the profile
# -> start the profile, maybe do some manual configuration (DOCUMENT IT)
# -> exit the profile by clearing all its data using the Firefox instance
# -> run the script on the profile
# -> the profile directory is now the new src/
#
# CONTROVERSIAL CONFIGURATION:
#
# "SmartBlock stands in for common tracking scripts, which are blocked in
# Private Browsing mode and in Enhanced Tracking Protection strict level. By
# doing so, it lets pages load more fully, with less breakage, without you
# having to do anything – all while keeping those tracking scripts blocked"
# "These fixes are there to make certain sites users have reported to us (via
# webcompat.com for instance) more usable and less broken, so you'll probably
# want to keep them enabled. They only kick in when you visit an affected site."
# "If you do want to disable an entire category for some reason, you can use
# the prefs you mentioned. Or if you want to disable just one specific fix in
# any category for testing, you can use about:compat, which lasts until you
# restart Firefox. There is also a way to disable one for good if a specific
# one is causing issues, but please let us know why in that case so we're aware
# and can hopefully fix any problems instead."
# - user_pref("extensions.webcompat.enable_shims", true);
# - user_pref("extensions.webcompat.perform_injections", true);

set -e

PREFS=./src/mscalindt/prefs.js

# This only cleans prefs.js; it is not supposed to actually induce any
# configuration modification.
if [ -f "$PREFS" ]; then
CLEANED_PREFS=$(
    while IFS= read -r LINE; do
        case "$LINE" in
            # REMOVE OUR CONFIGURED VALUES, FOR DIFF FOR NEW PROFILES FOR NEW
            # (UNHANDLED) STRINGS/CONFIGURATION
            #
            # FIREFOX MAY (HARD) OVERRIDE OUR CONFIGURATION, SO IT IS "FINE" IF
            # VALUES, LIKE `browser.laterrun.enabled`, DO NOT MATCH OUR AND IN
            # TURN REMAIN IN prefs.js REGARDLESS
            'user_pref("accessibility.force_disabled", 1);' | \
            'user_pref("app.normandy.enabled", false);' | \
            'user_pref("app.normandy.first_run", false);' | \
            'user_pref("app.shield.optoutstudies.enabled", false);' | \
            'user_pref("app.update.auto", false);' | \
            'user_pref("browser.aboutConfig.showWarning", false);' | \
            'user_pref("browser.aboutwelcome.enabled", false);' | \
            'user_pref("browser.cache.disk.enable", false);' | \
            'user_pref("browser.cache.memory.enable", false);' | \
            'user_pref("browser.contentblocking.category", "strict");' | \
            'user_pref("browser.display.document_color_use", 0);' | \
            'user_pref("browser.display.use_document_fonts", 0);' | \
            'user_pref("browser.download.dir", "/tmp");' | \
            'user_pref("browser.download.folderList", 2);' | \
            'user_pref("browser.download.open_pdf_attachments_inline", true);' | \
            'user_pref("browser.download.start_downloads_in_tmp_dir", true);' | \
            'user_pref("browser.ipProtection.enabled", false);' | \
            'user_pref("browser.ipProtection.autoStartEnabled", false);' | \
            'user_pref("browser.ipProtection.autoStartPrivateEnabled", false);' | \
            'user_pref("browser.ipProtection.autoRestoreEnabled", false);' | \
            'user_pref("browser.ipProtection.userEnabled", false);' | \
            'user_pref("browser.laterrun.enabled", false);' | \
            'user_pref("browser.ml.chat.enabled", false);' | \
            'user_pref("browser.ml.chat.menu", false);' | \
            'user_pref("browser.ml.chat.page", false);' | \
            'user_pref("browser.ml.enable", false);' | \
            'user_pref("browser.ml.linkPreview.enabled", false);' | \
            'user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);' | \
            'user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);' | \
            'user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);' | \
            'user_pref("browser.newtabpage.activity-stream.showSponsoredCheckboxes", false);' | \
            'user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);' | \
            'user_pref("browser.newtabpage.activity-stream.system.showWeatherOptIn", false);' | \
            'user_pref("browser.places.speculativeConnect.enabled", false);' | \
            'user_pref("browser.preferences.experimental.hidden", false);' | \
            'user_pref("browser.safebrowsing.allowOverride", false);' | \
            'user_pref("browser.safebrowsing.blockedURIs.enabled", false);' | \
            'user_pref("browser.safebrowsing.downloads.enabled", false);' | \
            'user_pref("browser.safebrowsing.downloads.remote.enabled", false);' | \
            'user_pref("browser.safebrowsing.malware.enabled", false);' | \
            'user_pref("browser.safebrowsing.phishing.enabled", false);' | \
            'user_pref("browser.sessionstore.interval", 120000);' | \
            'user_pref("browser.sessionstore.max_tabs_undo", 5);' | \
            'user_pref("browser.sessionstore.privacy_level", 2);' | \
            'user_pref("browser.startup.page", 3);' | \
            'user_pref("browser.tabs.delayHidingAudioPlayingIconMS", 0);' | \
            'user_pref("browser.tabs.groups.smart.enabled", false);' | \
            'user_pref("browser.tabs.groups.smart.userEnabled", false);' | \
            'user_pref("browser.tabs.splitView.enabled", false);' | \
            'user_pref("browser.theme.content-theme", 0);' | \
            'user_pref("browser.theme.toolbar-theme", 0);' | \
            'user_pref("browser.toolbars.bookmarks.visibility", "never");' | \
            'user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"ublock0_raymondhill_net-browser-action\",\"canvasblocker_kkapsner_de-browser-action\",\"_74145f27-f039-47ce-a470-a662b129930a_-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"vertical-spacer\",\"urlbar-container\",\"downloads-button\",\"unified-extensions-button\",\"library-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"import-button\",\"personal-bookmarks\"]},\"seen\":[\"developer-button\",\"screenshot-button\",\"canvasblocker_kkapsner_de-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"_74145f27-f039-47ce-a470-a662b129930a_-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"vertical-tabs\",\"PersonalToolbar\",\"TabsToolbar\",\"unified-extensions-area\",\"toolbar-menubar\"],\"currentVersion\":23,\"newElementCount\":3}");' | \
            'user_pref("browser.uidensity", 1);' | \
            'user_pref("browser.urlbar.placeholderName", "DuckDuckGo");' | \
            'user_pref("browser.urlbar.placeholderName.private", "DuckDuckGo");' | \
            'user_pref("browser.urlbar.showSearchSuggestionsFirst", false);' | \
            'user_pref("browser.urlbar.speculativeConnect.enabled", false);' | \
            'user_pref("browser.urlbar.suggest.engines", false);' | \
            'user_pref("browser.urlbar.suggest.openpage", false);' | \
            'user_pref("browser.urlbar.suggest.quickactions", false);' | \
            'user_pref("browser.urlbar.suggest.recentsearches", false);' | \
            'user_pref("browser.warnOnQuitShortcut", false);' | \
            'user_pref("datareporting.healthreport.uploadEnabled", false);' | \
            'user_pref("datareporting.policy.dataSubmissionEnabled", false);' | \
            'user_pref("datareporting.usage.uploadEnabled", false);' | \
            'user_pref("devtools.accessibility.enabled", false);' | \
            'user_pref("doh-rollout.disable-heuristics", true);' | \
            'user_pref("dom.security.https_only_mode", true);' | \
            'user_pref("dom.security.https_only_mode_ever_enabled", true);' | \
            'user_pref("dom.serviceWorkers.enabled", false);' | \
            'user_pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");' | \
            'user_pref("extensions.formautofill.addresses.enabled", false);' | \
            'user_pref("extensions.formautofill.creditCards.enabled", false);' | \
            'user_pref("extensions.ml.enabled", false);' | \
            'user_pref("extensions.pictureinpicture.enable_picture_in_picture_overrides", false);' | \
            'user_pref("extensions.ui.dictionary.hidden", true);' | \
            'user_pref("extensions.ui.extension.hidden", false);' | \
            'user_pref("extensions.ui.locale.hidden", true);' | \
            'user_pref("extensions.ui.mlmodel.hidden", true);' | \
            'user_pref("extensions.ui.sitepermission.hidden", true);' | \
            'user_pref("extensions.webcompat.enable_shims", true);' | \
            'user_pref("extensions.webcompat.perform_injections", true);' | \
            'user_pref("font.default.x-cyrillic", "sans-serif");' | \
            'user_pref("font.default.x-western", "sans-serif");' | \
            'user_pref("font.language.group", "x-western");' | \
            'user_pref("font.minimum-size.x-cyrillic", 13);' | \
            'user_pref("font.minimum-size.x-western", 13);' | \
            'user_pref("font.name.monospace.x-cyrillic", "Source Code Pro");' | \
            'user_pref("font.name.monospace.x-western", "Source Code Pro");' | \
            'user_pref("font.size.monospace.x-cyrillic", 13);' | \
            'user_pref("font.size.monospace.x-western", 13);' | \
            'user_pref("media.autoplay.default", 5);' | \
            'user_pref("media.eme.enabled", true);' | \
            'user_pref("media.navigator.enabled", false);' | \
            'user_pref("media.peerconnection.enabled", false);' | \
            'user_pref("media.videocontrols.picture-in-picture.enabled", false);' | \
            'user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);' | \
            'user_pref("mousebutton.4th.enabled", false);' | \
            'user_pref("mousebutton.5th.enabled", false);' | \
            'user_pref("mousewheel.min_line_scroll_amount", 15);' | \
            'user_pref("network.dns.disablePrefetch", true);' | \
            'user_pref("network.http.speculative-parallel-limit", 0);' | \
            'user_pref("network.lna.blocking", true);' | \
            'user_pref("network.lna.block_trackers", true);' | \
            'user_pref("network.lna.enabled", true);' | \
            'user_pref("network.predictor.enabled", false);' | \
            'user_pref("network.prefetch-next", false);' | \
            'user_pref("network.proxy.socks5_remote_dns", false);' | \
            'user_pref("network.trr.mode", 5);' | \
            'user_pref("nimbus.telemetry.targetingContextEnabled", false);' | \
            'user_pref("permissions.default.desktop-notification", 2);' | \
            'user_pref("permissions.default.xr", 2);' | \
            'user_pref("privacy.bounceTrackingProtection.mode", 1);' | \
            'user_pref("privacy.globalprivacycontrol.enabled", true);' | \
            'user_pref("privacy.trackingprotection.allow_list.baseline.enabled", false);' | \
            'user_pref("privacy.trackingprotection.enabled", true);' | \
            'user_pref("reader.parse-on-load.enabled", false);' | \
            'user_pref("screenshots.browser.component.enabled", false);' | \
            'user_pref("security.OCSP.enabled", 0);' | \
            'user_pref("sidebar.visibility", "hide-sidebar");' | \
            'user_pref("signon.management.page.breach-alerts.enabled", false);' | \
            'user_pref("signon.rememberSignons", false);' | \
            'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' | \
            'user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);' | \
            'user_pref("trailhead.firstrun.didSeeAboutWelcome", true);')
                continue
            ;;
            # IMPLICIT CONFIGURED VALUES
            #
            # THESE MAY HAVE TO EVENTUALLY BE EXPLICITLY CONFIGURED
            'user_pref("privacy.trackingprotection.allow_list.convenience.enabled", false);')
                continue
            ;;
            # THE GARBAGE THAT IS CLEANED:
            'user_pref("app.normandy.migrationsApplied"'* | \
            'user_pref("app.normandy.user_id"'* | \
            'user_pref("app.update.lastUpdateTime.addon-background-update-timer"'* | \
            'user_pref("app.update.lastUpdateTime.browser-cleanup-thumbnails"'* | \
            'user_pref("app.update.lastUpdateTime.glean-addons-daily"'* | \
            'user_pref("app.update.lastUpdateTime.recipe-client-addon-run"'* | \
            'user_pref("app.update.lastUpdateTime.region-update-timer"'* | \
            'user_pref("app.update.lastUpdateTime.rs-experiment-loader-timer"'* | \
            'user_pref("app.update.lastUpdateTime.search-engine-update-timer"'* | \
            'user_pref("app.update.lastUpdateTime.services-settings-poll-changes"'* | \
            'user_pref("app.update.lastUpdateTime.suggest-ingest"'* | \
            'user_pref("app.update.lastUpdateTime.telemetry_modules_ping"'* | \
            'user_pref("app.update.lastUpdateTime.xpi-signature-verification"'* | \
            'user_pref("browser.bookmarks.defaultLocation"'* | \
            'user_pref("browser.bookmarks.editDialog.confirmationHintShowCount"'* | \
            'user_pref("browser.contentblocking.report.hide_vpn_banner"'* | \
            'user_pref("browser.contextual-services.contextId"'* | \
            'user_pref("browser.contextual-services.contextId.timestamp-in-seconds"'* | \
            'user_pref("browser.download.lastDir"'* | \
            'user_pref("browser.download.save_converter_index"'* | \
            'user_pref("browser.download.viewableInternally.typeWasRegistered.avif"'* | \
            'user_pref("browser.download.viewableInternally.typeWasRegistered.webp"'* | \
            'user_pref("browser.eme.ui.firstContentShown"'* | \
            'user_pref("browser.engagement.library-button.has-used"'* | \
            'user_pref("browser.firefox-view.feature-tour"'* | \
            'user_pref("browser.firefox-view.view-count"'* | \
            'user_pref("browser.ipProtection.locationListCache"'* | \
            'user_pref("browser.laterrun.bookkeeping.profileCreationTime"'* | \
            'user_pref("browser.laterrun.bookkeeping.sessionCount"'* | \
            'user_pref("browser.migration.version"'* | \
            'user_pref("browser.ml.chat.nimbus"'* | \
            'user_pref("browser.newtabpage.activity-stream.impressionId"'* | \
            'user_pref("browser.newtabpage.pinned"'* | \
            'user_pref("browser.newtabpage.storageVersion"'* | \
            'user_pref("browser.pageActions.persistedActions"'* | \
            'user_pref("browser.pagethumbnails.storage_version"'* | \
            'user_pref("browser.region.update.updated"'* | \
            'user_pref("browser.rights.3.shown"'* | \
            'user_pref("browser.safebrowsing.provider.google4.lastupdatetime"'* | \
            'user_pref("browser.safebrowsing.provider.google4.nextupdatetime"'* | \
            'user_pref("browser.safebrowsing.provider.mozilla.lastupdatetime"'* | \
            'user_pref("browser.safebrowsing.provider.mozilla.nextupdatetime"'* | \
            'user_pref("browser.search.region"'* | \
            'user_pref("browser.search.serpEventTelemetryCategorization.regionEnabled"'* | \
            'user_pref("browser.search.totalSearches"'* | \
            'user_pref("browser.sessionstore.upgradeBackup.latestBuildID"'* | \
            'user_pref("browser.shell.mostRecentDateSetAsDefault"'* | \
            'user_pref("browser.startup.couldRestoreSession.count"'* | \
            'user_pref("browser.startup.homepage_override.buildID"'* | \
            'user_pref("browser.startup.homepage_override.mstone"'* | \
            'user_pref("browser.startup.lastColdStartupCheck"'* | \
            'user_pref("browser.startup.upgradeDialog.version"'* | \
            'user_pref("browser.tabs.firefox-view.ui-state.opentabs.open"'* | \
            'user_pref("browser.tabs.firefox-view.ui-state.syncedtabs.open"'* | \
            'user_pref("browser.tabs.firefox-view.ui-state.tab-pickup.open"'* | \
            'user_pref("browser.tabs.inTitlebar"'* | \
            'user_pref("browser.termsofuse.prefMigrationCheck"'* | \
            'user_pref("browser.translations.mostRecentTargetLanguages"'* | \
            'user_pref("browser.translations.panelShown"'* | \
            'user_pref("browser.urlbar.lastUrlbarSearchSeconds"'* | \
            'user_pref("browser.urlbar.quicksuggest.migrationVersion"'* | \
            'user_pref("browser.urlbar.quicksuggest.scenario"'* | \
            'user_pref("browser.urlbar.recentsearches.lastDefaultChanged"'* | \
            'user_pref("captchadetection.hasUnsubmittedData"'* | \
            'user_pref("captchadetection.lastSubmission"'* | \
            'user_pref("datareporting.dau.cachedUsageProfileGroupID"'* | \
            'user_pref("datareporting.dau.cachedUsageProfileID"'* | \
            'user_pref("datareporting.policy.dataSubmissionPolicyAcceptedVersion"'* | \
            'user_pref("datareporting.policy.dataSubmissionPolicyNotifiedTime"'* | \
            'user_pref("devtools.debugger.pending-selected-location"'* | \
            'user_pref("devtools.everOpened"'* | \
            'user_pref("distribution.archlinux.bookmarksProcessed"'* | \
            'user_pref("distribution.iniFile.exists.appversion"'* | \
            'user_pref("distribution.iniFile.exists.value"'* | \
            'user_pref("doh-rollout.home-region"'* | \
            'user_pref("dom.push.userAgentID"'* | \
            'user_pref("extensions.blocklist.pingCountVersion"'* | \
            'user_pref("extensions.colorway-builtin-themes-cleanup"'* | \
            'user_pref("extensions.databaseSchema"'* | \
            'user_pref("extensions.formautofill.creditCards.reauth.optout"'* | \
            'user_pref("extensions.getAddons.cache.lastUpdate"'* | \
            'user_pref("extensions.getAddons.databaseSchema"'* | \
            'user_pref("extensions.lastAppBuildId"'* | \
            'user_pref("extensions.lastAppVersion"'* | \
            'user_pref("extensions.lastPlatformVersion"'* | \
            'user_pref("extensions.quarantinedDomains.list"'* | \
            'user_pref("extensions.systemAddonSet"'* | \
            'user_pref("extensions.ui.lastCategory"'* | \
            'user_pref("extensions.webextensions.uuids"'* | \
            'user_pref("identity.fxaccounts.commands.missed.last_fetch"'* | \
            'user_pref("identity.fxaccounts.lastSignedInUserHash"'* | \
            'user_pref("identity.fxaccounts.toolbar.accessed"'* | \
            'user_pref("identity.fxaccounts.toolbar.syncSetup.panelAccessed"'* | \
            'user_pref("idle.lastDailyNotification"'* | \
            'user_pref("media.gmp-gmpopenh264.abi"'* | \
            'user_pref("media.gmp-gmpopenh264.hashValue"'* | \
            'user_pref("media.gmp-gmpopenh264.lastDownload"'* | \
            'user_pref("media.gmp-gmpopenh264.lastDownloadFailReason"'* | \
            'user_pref("media.gmp-gmpopenh264.lastDownloadFailed"'* | \
            'user_pref("media.gmp-gmpopenh264.lastInstallStart"'* | \
            'user_pref("media.gmp-gmpopenh264.lastUpdate"'* | \
            'user_pref("media.gmp-gmpopenh264.version"'* | \
            'user_pref("media.gmp-manager.buildID"'* | \
            'user_pref("media.gmp-manager.lastCheck"'* | \
            'user_pref("media.gmp-manager.lastEmptyCheck"'* | \
            'user_pref("media.gmp-widevinecdm.abi"'* | \
            'user_pref("media.gmp-widevinecdm.hashValue"'* | \
            'user_pref("media.gmp-widevinecdm.lastDownload"'* | \
            'user_pref("media.gmp-widevinecdm.lastDownloadFailReason"'* | \
            'user_pref("media.gmp-widevinecdm.lastDownloadFailed"'* | \
            'user_pref("media.gmp-widevinecdm.lastInstallStart"'* | \
            'user_pref("media.gmp-widevinecdm.lastUpdate"'* | \
            'user_pref("media.gmp-widevinecdm.version"'* | \
            'user_pref("media.gmp.storage.version.observed"'* | \
            'user_pref("network.cookie.CHIPS.lastMigrateDatabase"'* | \
            'user_pref("nimbus.migrations.after-remote-settings-update"'* | \
            'user_pref("nimbus.migrations.after-store-initialized"'* | \
            'user_pref("nimbus.migrations.init-started"'* | \
            'user_pref("nimbus.profileId"'* | \
            'user_pref("pdfjs.enabledCache.state"'* | \
            'user_pref("pdfjs.migrationVersion"'* | \
            'user_pref("places.database.lastMaintenance"'* | \
            'user_pref("pref.privacy.disable_button.cookie_exceptions"'* | \
            'user_pref("pref.privacy.disable_button.tracking_protection_exceptions"'* | \
            'user_pref("privacy.purge_trackers.date_in_cookie_database"'* | \
            'user_pref("privacy.purge_trackers.last_purge"'* | \
            'user_pref("privacy.trackingprotection.allow_list.hasMigratedCategoryPrefs"'* | \
            'user_pref("security.sandbox.content.tempDirSuffix"'* | \
            'user_pref("services.settings.blocklists.addons-bloomfilters.last_check"'* | \
            'user_pref("services.settings.blocklists.gfx.last_check"'* | \
            'user_pref("services.settings.clock_skew_seconds"'* | \
            'user_pref("services.settings.last_etag"'* | \
            'user_pref("services.settings.last_update_seconds"'* | \
            'user_pref("services.settings.main.addons-data-leak-blocker-domains.last_check"'* | \
            'user_pref("services.settings.main.addons-manager-settings.last_check"'* | \
            'user_pref("services.settings.main.ai-window-prompts.last_check"'* | \
            'user_pref("services.settings.main.anti-tracking-url-decoration.last_check"'* | \
            'user_pref("services.settings.main.bounce-tracking-protection-exceptions.last_check"'* | \
            'user_pref("services.settings.main.cfr.last_check"'* | \
            'user_pref("services.settings.main.cookie-banner-rules-list.last_check"'* | \
            'user_pref("services.settings.main.crash-reports-ondemand.last_check"'* | \
            'user_pref("services.settings.main.devtools-compatibility-browsers.last_check"'* | \
            'user_pref("services.settings.main.devtools-devices.last_check"'* | \
            'user_pref("services.settings.main.doh-config.last_check"'* | \
            'user_pref("services.settings.main.doh-providers.last_check"'* | \
            'user_pref("services.settings.main.fingerprinting-protection-overrides.last_check"'* | \
            'user_pref("services.settings.main.fxmonitor-breaches.last_check"'* | \
            'user_pref("services.settings.main.hijack-blocklists.last_check"'* | \
            'user_pref("services.settings.main.language-dictionaries.last_check"'* | \
            'user_pref("services.settings.main.message-groups.last_check"'* | \
            'user_pref("services.settings.main.moz-essential-domain-fallbacks.last_check"'* | \
            'user_pref("services.settings.main.ms-language-packs.last_check"'* | \
            'user_pref("services.settings.main.newtab-frecency-boosted-sponsors.last_check"'* | \
            'user_pref("services.settings.main.newtab-wallpapers-v2.last_check"'* | \
            'user_pref("services.settings.main.nimbus-desktop-experiments.last_check"'* | \
            'user_pref("services.settings.main.nimbus-secure-experiments.last_check"'* | \
            'user_pref("services.settings.main.normandy-recipes-capabilities.last_check"'* | \
            'user_pref("services.settings.main.partitioning-exempt-urls.last_check"'* | \
            'user_pref("services.settings.main.password-recipes.last_check"'* | \
            'user_pref("services.settings.main.password-rules.last_check"'* | \
            'user_pref("services.settings.main.pioneer-study-addons-v1.last_check"'* | \
            'user_pref("services.settings.main.public-suffix-list.last_check"'* | \
            'user_pref("services.settings.main.query-stripping.last_check"'* | \
            'user_pref("services.settings.main.remote-permissions.last_check"'* | \
            'user_pref("services.settings.main.search-categorization.last_check"'* | \
            'user_pref("services.settings.main.search-config-icons.last_check"'* | \
            'user_pref("services.settings.main.search-config-overrides-v2.last_check"'* | \
            'user_pref("services.settings.main.search-config-overrides.last_check"'* | \
            'user_pref("services.settings.main.search-config-v2.last_check"'* | \
            'user_pref("services.settings.main.search-config.last_check"'* | \
            'user_pref("services.settings.main.search-default-override-allowlist.last_check"'* | \
            'user_pref("services.settings.main.search-telemetry-v2.last_check"'* | \
            'user_pref("services.settings.main.sites-classification.last_check"'* | \
            'user_pref("services.settings.main.third-party-cookie-blocking-exempt-urls.last_check"'* | \
            'user_pref("services.settings.main.tippytop.last_check"'* | \
            'user_pref("services.settings.main.top-sites.last_check"'* | \
            'user_pref("services.settings.main.tracking-protection-lists.last_check"'* | \
            'user_pref("services.settings.main.translations-identification-models.last_check"'* | \
            'user_pref("services.settings.main.translations-models.last_check"'* | \
            'user_pref("services.settings.main.translations-models-v2.last_check"'* | \
            'user_pref("services.settings.main.translations-wasm.last_check"'* | \
            'user_pref("services.settings.main.url-classifier-exceptions.last_check"'* | \
            'user_pref("services.settings.main.url-classifier-skip-urls.last_check"'* | \
            'user_pref("services.settings.main.url-parser-default-unknown-schemes-interventions.last_check"'* | \
            'user_pref("services.settings.main.urlbar-persisted-search-terms.last_check"'* | \
            'user_pref("services.settings.main.vpn-serverlist.last_check"'* | \
            'user_pref("services.settings.main.webcompat-interventions.last_check"'* | \
            'user_pref("services.settings.main.websites-with-shared-credential-backends.last_check"'* | \
            'user_pref("services.settings.main.whats-new-panel.last_check"'* | \
            'user_pref("services.settings.security-state.cert-revocations.last_check"'* | \
            'user_pref("services.settings.security-state.intermediates.last_check"'* | \
            'user_pref("services.settings.security-state.onecrl.last_check"'* | \
            'user_pref("services.sync.clients.lastSync"'* | \
            'user_pref("services.sync.globalScore"'* | \
            'user_pref("services.sync.lastversion"'* | \
            'user_pref("services.sync.nextSync"'* | \
            'user_pref("sidebar.backupState"'* | \
            'user_pref("sidebar.main.tools"'* | \
            'user_pref("sidebar.nimbus"'* | \
            'user_pref("sidebar.notification.badge.aichat"'* | \
            'user_pref("signon.management.page.os-auth.optout"'* | \
            'user_pref("storage.vacuum.last.content-prefs.sqlite"'* | \
            'user_pref("storage.vacuum.last.index"'* | \
            'user_pref("storage.vacuum.last.places.sqlite"'* | \
            'user_pref("toolkit.profiles.storeID"'* | \
            'user_pref("toolkit.startup.last_success"'* | \
            'user_pref("toolkit.telemetry.cachedClientID"'* | \
            'user_pref("toolkit.telemetry.cachedProfileGroupID"'* | \
            'user_pref("toolkit.telemetry.pioneer-new-studies-available"'* | \
            'user_pref("toolkit.telemetry.previousBuildID"'*)
                continue
            ;;
        esac

        printf "%s\n" "$LINE"
    done < "$PREFS"
)
fi

# Profile cleanup.
if [ "$CLEANED_PREFS" ]; then
    printf "%s\n" "$CLEANED_PREFS" > "$PREFS"
fi
rm -rf \
    ./src/mscalindt/bookmarkbackups \
    ./src/mscalindt/crashes \
    ./src/mscalindt/datareporting \
    ./src/mscalindt/extension-store \
    ./src/mscalindt/extension-store-menus \
    ./src/mscalindt/gmp-gmpopenh264 \
    ./src/mscalindt/gmp-widevinecdm \
    ./src/mscalindt/minidumps \
    ./src/mscalindt/saved-telemetry-pings \
    ./src/mscalindt/security_state \
    ./src/mscalindt/sessionstore-backups \
    ./src/mscalindt/sessionstore-logs \
    ./src/mscalindt/settings \
    ./src/mscalindt/storage \
    ./src/mscalindt/.parentlock \
    ./src/mscalindt/addonStartup.json.lz4 \
    ./src/mscalindt/AlternateServices.bin \
    ./src/mscalindt/bounce-tracking-protection.sqlite \
    ./src/mscalindt/broadcast-listeners.json \
    ./src/mscalindt/cert9.db \
    ./src/mscalindt/cert_override.txt \
    ./src/mscalindt/chat-store.sqlite \
    ./src/mscalindt/chat-store.sqlite-wal \
    ./src/mscalindt/compatibility.ini \
    ./src/mscalindt/containers.json \
    ./src/mscalindt/content-prefs.sqlite \
    ./src/mscalindt/cookies.sqlite \
    ./src/mscalindt/cookies.sqlite-wal \
    ./src/mscalindt/domain_to_categories.sqlite \
    ./src/mscalindt/domain_to_categories.sqlite-journal \
    ./src/mscalindt/enumerate_devices.txt \
    ./src/mscalindt/ExperimentStoreData.json \
    ./src/mscalindt/favicons.sqlite \
    ./src/mscalindt/favicons.sqlite-wal \
    ./src/mscalindt/formhistory.sqlite \
    ./src/mscalindt/handlers.json \
    ./src/mscalindt/key4.db \
    ./src/mscalindt/lock \
    ./src/mscalindt/logins.db \
    ./src/mscalindt/permissions.sqlite \
    ./src/mscalindt/pkcs11.txt \
    ./src/mscalindt/places.sqlite \
    ./src/mscalindt/places.sqlite-wal \
    ./src/mscalindt/protections.sqlite \
    ./src/mscalindt/sessionCheckpoints.json \
    ./src/mscalindt/sessionstore.jsonlz4 \
    ./src/mscalindt/SiteSecurityServiceState.bin \
    ./src/mscalindt/storage-sync-v2.sqlite \
    ./src/mscalindt/storage.sqlite \
    ./src/mscalindt/suggest.sqlite \
    ./src/mscalindt/suggest.sqlite-shm \
    ./src/mscalindt/suggest.sqlite-wal \
    ./src/mscalindt/webappsstore.sqlite \
    ./src/mscalindt/webappsstore.sqlite-wal \
    ./src/mscalindt/xulstore.json

# Our configuration.
[ ! -e ./src/mscalindt/chrome ] && mkdir ./src/mscalindt/chrome || :
printf "%s" \
'/* Remove close button from tabs */
.tabbrowser-tab:not([pinned]) .tab-close-button { display:none !important; }

/* Remove fullscreen transition animation */
#navigator-toolbox[fullscreenShouldAnimate] { transition:none !important; }

/* Remove close button at the end of toolbar */
.titlebar-close,
#titlebar .titlebar-close,
.titlebar-buttonbox .titlebar-close {
  display: none !important;
  visibility: hidden !important;
  pointer-events: none !important;
}

/* Remove navigation controls from the context menu */
#context-navigation,
#context-sep-navigation {
  display: none !important;
}

/* Remove "Print Selection" from the context menu */
#context-print-selection {
  display: none !important;
}
' > ./src/mscalindt/chrome/userChrome.css
printf "%s" \
'user_pref("accessibility.force_disabled", 1);
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.first_run", false);
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("app.update.auto", false);
user_pref("browser.aboutConfig.showWarning", false);
user_pref("browser.aboutwelcome.enabled", false);
user_pref("browser.cache.disk.enable", false);
user_pref("browser.cache.memory.enable", false);
user_pref("browser.contentblocking.category", "strict");
user_pref("browser.display.document_color_use", 0);
user_pref("browser.display.use_document_fonts", 0);
user_pref("browser.download.dir", "/tmp");
user_pref("browser.download.folderList", 2);
user_pref("browser.download.open_pdf_attachments_inline", true);
user_pref("browser.download.start_downloads_in_tmp_dir", true);
user_pref("browser.ipProtection.enabled", false);
user_pref("browser.ipProtection.autoStartEnabled", false);
user_pref("browser.ipProtection.autoStartPrivateEnabled", false);
user_pref("browser.ipProtection.autoRestoreEnabled", false);
user_pref("browser.ipProtection.userEnabled", false);
user_pref("browser.laterrun.enabled", false);
user_pref("browser.ml.chat.enabled", false);
user_pref("browser.ml.chat.menu", false);
user_pref("browser.ml.chat.page", false);
user_pref("browser.ml.enable", false);
user_pref("browser.ml.linkPreview.enabled", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredCheckboxes", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.system.showWeatherOptIn", false);
user_pref("browser.places.speculativeConnect.enabled", false);
user_pref("browser.preferences.experimental.hidden", false);
user_pref("browser.safebrowsing.allowOverride", false);
user_pref("browser.safebrowsing.blockedURIs.enabled", false);
user_pref("browser.safebrowsing.downloads.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.enabled", false);
user_pref("browser.safebrowsing.malware.enabled", false);
user_pref("browser.safebrowsing.phishing.enabled", false);
user_pref("browser.sessionstore.interval", 120000);
user_pref("browser.sessionstore.max_tabs_undo", 5);
user_pref("browser.sessionstore.privacy_level", 2);
user_pref("browser.startup.page", 3);
user_pref("browser.tabs.delayHidingAudioPlayingIconMS", 0);
user_pref("browser.tabs.groups.smart.enabled", false);
user_pref("browser.tabs.groups.smart.userEnabled", false);
user_pref("browser.tabs.splitView.enabled", false);
user_pref("browser.theme.content-theme", 0);
user_pref("browser.theme.toolbar-theme", 0);
user_pref("browser.toolbars.bookmarks.visibility", "never");
user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"ublock0_raymondhill_net-browser-action\",\"canvasblocker_kkapsner_de-browser-action\",\"_74145f27-f039-47ce-a470-a662b129930a_-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"vertical-spacer\",\"urlbar-container\",\"downloads-button\",\"unified-extensions-button\",\"library-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"import-button\",\"personal-bookmarks\"]},\"seen\":[\"developer-button\",\"screenshot-button\",\"canvasblocker_kkapsner_de-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"_74145f27-f039-47ce-a470-a662b129930a_-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"vertical-tabs\",\"PersonalToolbar\",\"TabsToolbar\",\"unified-extensions-area\",\"toolbar-menubar\"],\"currentVersion\":23,\"newElementCount\":3}");
user_pref("browser.uidensity", 1);
user_pref("browser.urlbar.placeholderName", "DuckDuckGo");
user_pref("browser.urlbar.placeholderName.private", "DuckDuckGo");
user_pref("browser.urlbar.showSearchSuggestionsFirst", false);
user_pref("browser.urlbar.speculativeConnect.enabled", false);
user_pref("browser.urlbar.suggest.engines", false);
user_pref("browser.urlbar.suggest.openpage", false);
user_pref("browser.urlbar.suggest.quickactions", false);
user_pref("browser.urlbar.suggest.recentsearches", false);
user_pref("browser.warnOnQuitShortcut", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.usage.uploadEnabled", false);
user_pref("devtools.accessibility.enabled", false);
user_pref("doh-rollout.disable-heuristics", true);
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_ever_enabled", true);
user_pref("dom.serviceWorkers.enabled", false);
user_pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);
user_pref("extensions.ml.enabled", false);
user_pref("extensions.pictureinpicture.enable_picture_in_picture_overrides", false);
user_pref("extensions.ui.dictionary.hidden", true);
user_pref("extensions.ui.extension.hidden", false);
user_pref("extensions.ui.locale.hidden", true);
user_pref("extensions.ui.mlmodel.hidden", true);
user_pref("extensions.ui.sitepermission.hidden", true);
user_pref("extensions.webcompat.enable_shims", true);
user_pref("extensions.webcompat.perform_injections", true);
user_pref("font.default.x-cyrillic", "sans-serif");
user_pref("font.default.x-western", "sans-serif");
user_pref("font.language.group", "x-western");
user_pref("font.minimum-size.x-cyrillic", 13);
user_pref("font.minimum-size.x-western", 13);
user_pref("font.name.monospace.x-cyrillic", "Source Code Pro");
user_pref("font.name.monospace.x-western", "Source Code Pro");
user_pref("font.size.monospace.x-cyrillic", 13);
user_pref("font.size.monospace.x-western", 13);
user_pref("media.autoplay.default", 5);
user_pref("media.eme.enabled", true);
user_pref("media.navigator.enabled", false);
user_pref("media.peerconnection.enabled", false);
user_pref("media.videocontrols.picture-in-picture.enabled", false);
user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);
user_pref("mousebutton.4th.enabled", false);
user_pref("mousebutton.5th.enabled", false);
user_pref("mousewheel.min_line_scroll_amount", 15);
user_pref("nimbus.telemetry.targetingContextEnabled", false);
user_pref("network.dns.disablePrefetch", true);
user_pref("network.http.speculative-parallel-limit", 0);
user_pref("network.lna.blocking", true);
user_pref("network.lna.block_trackers", true);
user_pref("network.lna.enabled", true);
user_pref("network.predictor.enabled", false);
user_pref("network.prefetch-next", false);
user_pref("network.proxy.socks5_remote_dns", false);
user_pref("network.trr.mode", 5);
user_pref("permissions.default.desktop-notification", 2);
user_pref("permissions.default.xr", 2);
user_pref("privacy.bounceTrackingProtection.mode", 1);
user_pref("privacy.globalprivacycontrol.enabled", true);
user_pref("privacy.trackingprotection.allow_list.baseline.enabled", false);
user_pref("privacy.trackingprotection.enabled", true);
user_pref("reader.parse-on-load.enabled", false);
user_pref("screenshots.browser.component.enabled", false);
user_pref("security.OCSP.enabled", 0);
user_pref("sidebar.visibility", "hide-sidebar");
user_pref("signon.management.page.breach-alerts.enabled", false);
user_pref("signon.rememberSignons", false);
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
user_pref("trailhead.firstrun.didSeeAboutWelcome", true);
' > ./src/mscalindt/user.js
