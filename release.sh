set -e

DIR="$(cd "${0%/*}" && printf "%s" "$PWD")"
PREFS="$DIR"/src/mscalindt/prefs.js
CLEANED_PREFS=$(
    while IFS= read -r LINE; do
        case "$LINE" in
            'user_pref("browser.safebrowsing.provider.mozilla.nextupdatetime"'*)
                LINE='user_pref("browser.safebrowsing.provider.mozilla.nextupdatetime", "1");'
            ;;
            'user_pref("browser.startup.couldRestoreSession.count"'*)
                LINE='user_pref("browser.startup.couldRestoreSession.count", 0);'
            ;;
            'user_pref("sidebar.backupState"'*)
                LINE='user_pref("sidebar.backupState", "{}");'
            ;;
            # explicitly configured vals
            #
            # unexpected values:
            # - `browser.laterrun.enabled` = `true`; reason: overriden by
            #   firefox to always activate for "new profiles".
            'user_pref("accessibility.force_disabled", 1);' | \
            'user_pref("app.normandy.enabled", false);' | \
            'user_pref("app.normandy.first_run", false);' | \
            'user_pref("app.shield.optoutstudies.enabled", false);' | \
            'user_pref("app.update.auto", false);' | \
            'user_pref("browser.aboutConfig.showWarning", false);' | \
            'user_pref("browser.aboutwelcome.enabled", false);' | \
            'user_pref("browser.cache.disk.enable", false);' | \
            'user_pref("browser.cache.memory.enable", false);' | \
            'user_pref("browser.download.start_downloads_in_tmp_dir", true);' | \
            'user_pref("browser.laterrun.enabled", false);' | \
            'user_pref("browser.ml.chat.enabled", false);' | \
            'user_pref("browser.ml.chat.page", false);' | \
            'user_pref("browser.ml.enable", false);' | \
            'user_pref("browser.ml.linkPreview.enabled", false);' | \
            'user_pref("browser.places.speculativeConnect.enabled", false);' | \
            'user_pref("browser.safebrowsing.allowOverride", false);' | \
            'user_pref("browser.safebrowsing.blockedURIs.enabled", false);' | \
            'user_pref("browser.safebrowsing.downloads.enabled", false);' | \
            'user_pref("browser.safebrowsing.downloads.remote.enabled", false);' | \
            'user_pref("browser.sessionstore.interval", 120000);' | \
            'user_pref("browser.sessionstore.max_tabs_undo", 5);' | \
            'user_pref("browser.sessionstore.privacy_level", 2);' | \
            'user_pref("browser.tabs.delayHidingAudioPlayingIconMS", 0);' | \
            'user_pref("browser.urlbar.speculativeConnect.enabled", false);' | \
            'user_pref("datareporting.policy.dataSubmissionEnabled", false);' | \
            'user_pref("dom.serviceWorkers.enabled", false);' | \
            'user_pref("extensions.pictureinpicture.enable_picture_in_picture_overrides", false);' | \
            'user_pref("media.navigator.enabled", false);' | \
            'user_pref("media.peerconnection.enabled", false);' | \
            'user_pref("media.videocontrols.picture-in-picture.enabled", false);' | \
            'user_pref("mousebutton.4th.enabled", false);' | \
            'user_pref("mousebutton.5th.enabled", false);' | \
            'user_pref("mousewheel.min_line_scroll_amount", 15);' | \
            'user_pref("network.http.speculative-parallel-limit", 0);' | \
            'user_pref("reader.parse-on-load.enabled", false);' | \
            'user_pref("screenshots.browser.component.enabled", false);' | \
            'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);')
                continue
            ;;
            # implicitly expected/configured vals
            'user_pref("privacy.trackingprotection.allow_list.convenience.enabled", false);')
                continue
            ;;
            # the following entries are peculiar and separately stripped
            'user_pref("browser.bookmarks.defaultLocation"'* | \
            'user_pref("browser.firefox-view.feature-tour"'* | \
            'user_pref("browser.firefox-view.view-count"'* | \
            'user_pref("browser.search.totalSearches"'* | \
            'user_pref("browser.tabs.inTitlebar"'* | \
            'user_pref("browser.termsofuse.prefMigrationCheck"'* | \
            'user_pref("datareporting.policy.dataSubmissionPolicyAcceptedVersion"'* | \
            'user_pref("datareporting.policy.dataSubmissionPolicyNotifiedTime"'* | \
            'user_pref("devtools.debugger.pending-selected-location"'* | \
            'user_pref("identity.fxaccounts.toolbar.accessed"'* | \
            'user_pref("identity.fxaccounts.toolbar.syncSetup.panelAccessed"'* | \
            'user_pref("privacy.trackingprotection.allow_list.hasMigratedCategoryPrefs"'* | \
            'user_pref("services.sync.lastversion"'*)
                continue
            ;;
            # the following entries are garbage leftovers that must be stripped
            'user_pref("app.normandy.migrationsApplied"'* | \
            'user_pref("app.normandy.user_id"'* | \
            'user_pref("app.update.lastUpdateTime.addon-background-update-timer"'* | \
            'user_pref("app.update.lastUpdateTime.browser-cleanup-thumbnails"'* | \
            'user_pref("app.update.lastUpdateTime.recipe-client-addon-run"'* | \
            'user_pref("app.update.lastUpdateTime.region-update-timer"'* | \
            'user_pref("app.update.lastUpdateTime.rs-experiment-loader-timer"'* | \
            'user_pref("app.update.lastUpdateTime.search-engine-update-timer"'* | \
            'user_pref("app.update.lastUpdateTime.services-settings-poll-changes"'* | \
            'user_pref("app.update.lastUpdateTime.telemetry_modules_ping"'* | \
            'user_pref("app.update.lastUpdateTime.xpi-signature-verification"'* | \
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
            'user_pref("browser.search.region"'* | \
            'user_pref("browser.search.serpEventTelemetryCategorization.regionEnabled"'* | \
            'user_pref("browser.sessionstore.upgradeBackup.latestBuildID"'* | \
            'user_pref("browser.shell.mostRecentDateSetAsDefault"'* | \
            'user_pref("browser.startup.homepage_override.buildID"'* | \
            'user_pref("browser.startup.homepage_override.mstone"'* | \
            'user_pref("browser.startup.lastColdStartupCheck"'* | \
            'user_pref("browser.startup.upgradeDialog.version"'* | \
            'user_pref("browser.tabs.firefox-view.ui-state.opentabs.open"'* | \
            'user_pref("browser.tabs.firefox-view.ui-state.syncedtabs.open"'* | \
            'user_pref("browser.tabs.firefox-view.ui-state.tab-pickup.open"'* | \
            'user_pref("browser.translations.mostRecentTargetLanguages"'* | \
            'user_pref("browser.translations.panelShown"'* | \
            'user_pref("browser.urlbar.quicksuggest.migrationVersion"'* | \
            'user_pref("browser.urlbar.quicksuggest.scenario"'* | \
            'user_pref("browser.urlbar.recentsearches.lastDefaultChanged"'* | \
            'user_pref("captchadetection.hasUnsubmittedData"'* | \
            'user_pref("captchadetection.lastSubmission"'* | \
            'user_pref("datareporting.dau.cachedUsageProfileGroupID"'* | \
            'user_pref("datareporting.dau.cachedUsageProfileID"'* | \
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
            'user_pref("identity.fxaccounts.commands.missed.last_fetch"'* | \
            'user_pref("identity.fxaccounts.lastSignedInUserHash"'* | \
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
            'user_pref("security.sandbox.content.tempDirSuffix"'* | \
            'user_pref("services.settings.blocklists.addons-bloomfilters.last_check"'* | \
            'user_pref("services.settings.blocklists.gfx.last_check"'* | \
            'user_pref("services.settings.clock_skew_seconds"'* | \
            'user_pref("services.settings.last_etag"'* | \
            'user_pref("services.settings.last_update_seconds"'* | \
            'user_pref("services.settings.main.addons-manager-settings.last_check"'* | \
            'user_pref("services.settings.main.anti-tracking-url-decoration.last_check"'* | \
            'user_pref("services.settings.main.bounce-tracking-protection-exceptions.last_check"'* | \
            'user_pref("services.settings.main.cfr.last_check"'* | \
            'user_pref("services.settings.main.cookie-banner-rules-list.last_check"'* | \
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
            'user_pref("services.settings.main.translations-wasm.last_check"'* | \
            'user_pref("services.settings.main.url-classifier-exceptions.last_check"'* | \
            'user_pref("services.settings.main.url-classifier-skip-urls.last_check"'* | \
            'user_pref("services.settings.main.url-parser-default-unknown-schemes-interventions.last_check"'* | \
            'user_pref("services.settings.main.urlbar-persisted-search-terms.last_check"'* | \
            'user_pref("services.settings.main.websites-with-shared-credential-backends.last_check"'* | \
            'user_pref("services.settings.main.whats-new-panel.last_check"'* | \
            'user_pref("services.settings.security-state.cert-revocations.last_check"'* | \
            'user_pref("services.settings.security-state.intermediates.last_check"'* | \
            'user_pref("services.settings.security-state.onecrl.last_check"'* | \
            'user_pref("services.sync.clients.lastSync"'* | \
            'user_pref("services.sync.globalScore"'* | \
            'user_pref("services.sync.nextSync"'* | \
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

# cleanup
printf "%s\n" "$CLEANED_PREFS" > "$PREFS"
rm -rf \
    "$DIR"/src/mscalindt/bookmarkbackups \
    "$DIR"/src/mscalindt/crashes \
    "$DIR"/src/mscalindt/datareporting \
    "$DIR"/src/mscalindt/extension-store \
    "$DIR"/src/mscalindt/extension-store-menus \
    "$DIR"/src/mscalindt/gmp-gmpopenh264 \
    "$DIR"/src/mscalindt/gmp-widevinecdm \
    "$DIR"/src/mscalindt/minidumps \
    "$DIR"/src/mscalindt/saved-telemetry-pings \
    "$DIR"/src/mscalindt/security_state \
    "$DIR"/src/mscalindt/sessionstore-backups \
    "$DIR"/src/mscalindt/settings \
    "$DIR"/src/mscalindt/storage \
    "$DIR"/src/mscalindt/.parentlock \
    "$DIR"/src/mscalindt/addonStartup.json.lz4 \
    "$DIR"/src/mscalindt/bounce-tracking-protection.sqlite \
    "$DIR"/src/mscalindt/broadcast-listeners.json \
    "$DIR"/src/mscalindt/cert9.db \
    "$DIR"/src/mscalindt/cert_override.txt \
    "$DIR"/src/mscalindt/compatibility.ini \
    "$DIR"/src/mscalindt/containers.json \
    "$DIR"/src/mscalindt/content-prefs.sqlite \
    "$DIR"/src/mscalindt/cookies.sqlite \
    "$DIR"/src/mscalindt/cookies.sqlite-wal \
    "$DIR"/src/mscalindt/domain_to_categories.sqlite \
    "$DIR"/src/mscalindt/domain_to_categories.sqlite-journal \
    "$DIR"/src/mscalindt/enumerate_devices.txt \
    "$DIR"/src/mscalindt/ExperimentStoreData.json \
    "$DIR"/src/mscalindt/favicons.sqlite \
    "$DIR"/src/mscalindt/favicons.sqlite-wal \
    "$DIR"/src/mscalindt/formhistory.sqlite \
    "$DIR"/src/mscalindt/handlers.json \
    "$DIR"/src/mscalindt/key4.db \
    "$DIR"/src/mscalindt/lock \
    "$DIR"/src/mscalindt/permissions.sqlite \
    "$DIR"/src/mscalindt/pkcs11.txt \
    "$DIR"/src/mscalindt/places.sqlite \
    "$DIR"/src/mscalindt/places.sqlite-wal \
    "$DIR"/src/mscalindt/protections.sqlite \
    "$DIR"/src/mscalindt/sessionCheckpoints.json \
    "$DIR"/src/mscalindt/sessionstore.jsonlz4 \
    "$DIR"/src/mscalindt/storage-sync-v2.sqlite \
    "$DIR"/src/mscalindt/storage.sqlite \
    "$DIR"/src/mscalindt/xulstore.json

# cfg
[ ! -e "$DIR"/src/mscalindt/chrome ] && mkdir "$DIR"/src/mscalindt/chrome || :
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
' > "$DIR"/src/mscalindt/chrome/userChrome.css
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
user_pref("browser.download.start_downloads_in_tmp_dir", true);
user_pref("browser.laterrun.enabled", false);
user_pref("browser.ml.chat.enabled", false);
user_pref("browser.ml.chat.page", false);
user_pref("browser.ml.enable", false);
user_pref("browser.ml.linkPreview.enabled", false);
user_pref("browser.places.speculativeConnect.enabled", false);
user_pref("browser.safebrowsing.allowOverride", false);
user_pref("browser.safebrowsing.blockedURIs.enabled", false);
user_pref("browser.safebrowsing.downloads.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.enabled", false);
user_pref("browser.sessionstore.interval", 120000);
user_pref("browser.sessionstore.max_tabs_undo", 5);
user_pref("browser.sessionstore.privacy_level", 2);
user_pref("browser.tabs.delayHidingAudioPlayingIconMS", 0);
user_pref("browser.urlbar.speculativeConnect.enabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("dom.serviceWorkers.enabled", false);
user_pref("extensions.pictureinpicture.enable_picture_in_picture_overrides", false);
user_pref("media.navigator.enabled", false);
user_pref("media.peerconnection.enabled", false);
user_pref("media.videocontrols.picture-in-picture.enabled", false);
user_pref("mousebutton.4th.enabled", false);
user_pref("mousebutton.5th.enabled", false);
user_pref("mousewheel.min_line_scroll_amount", 15);
user_pref("network.http.speculative-parallel-limit", 0);
user_pref("reader.parse-on-load.enabled", false);
user_pref("screenshots.browser.component.enabled", false);
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
' > "$DIR"/src/mscalindt/user.js
