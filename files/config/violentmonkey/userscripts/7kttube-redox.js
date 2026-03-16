// ==UserScript==
// @name			7ktTube | 2016 REDUX
// @namespace STILL_ALIVE
// @version         4.5.75
// @description     Old YouTube 2016 Layout | Old watchpage | Change thumbnail & video player size | grayscale seen video thumbnails | Hide suggestion blocks, category/filter bars | Square profile-pictures | Disable hover thumbnail previews | and much more!
// @author          7KT-SWE
// @icon            https://www.gnu.org/graphics/gerwinski-gnu-head.png
// @icon64          https://www.gnu.org/graphics/gerwinski-gnu-head.png
// @license         GPL-3.0-only
// @homepageURL     https://7kt.se/
// @downloadURL	    https://7kt.se/install/7ktTube.user.js
// @updateURL	    https://7kt.se/install/7ktTube.user.js
// @supportURL      https://discord.com/invite/7WRjXHMfXJ
// @contributionURL https://www.paypal.com/donate/?hosted_button_id=2EJR4DLTR4Y7Q
// BEGIN MODULES
// @require         https://7kt.se/resources/modules/beta/tempcssfix.js?v=4575
// @require         https://7kt.se/resources/modules/456/flags.js?v=4573
// @require         https://7kt.se/resources/modules/456/home.js?v=4573
// @require         https://7kt.se/resources/modules/beta/settings.js?v=4573
// @require         https://7kt.se/resources/modules/456/styles.js?v=4573
// @require         https://7kt.se/resources/modules/456/watch.js?v=4573
// @require         https://7kt.se/resources/modules/beta/player_ui.js?v=4572
// @require         https://update.greasyfork.org/scripts/28536/184529/GM_config.js
// END MODULES
// @match       *://*.youtube.com/*
// @exclude     https://m.youtube.com/*
// @grant       GM_addStyle
// @grant       GM_getValue
// @grant       GM.getValue
// @grant       GM.setValue
// @grant       GM_setValue
// @grant       GM_registerMenuCommand
// @grant       GM_addElement
// @grant       unsafeWindow
// @run-at      document-start

// ==/UserScript==
/*jshint esversion: 6 */
// fix GM_addStyle

if (typeof GM_addStyle !== "function") {
    function GM_addStyle(css) {
        let style = document.createElement('style');
        style.type = 'text/css';
        style.appendChild(document.createTextNode(css));
        const head = document.documentElement ?? document.getElementsByTagName("head")[0];
        head.appendChild(style);
    }
}

function removePlayerElements() {
    document.querySelectorAll("#masthead-ad,#root").forEach(e => e.remove());
    document.querySelector(".ytp-miniplayer-button")?.remove();
  //document.querySelector("ytd-miniplayer")?.remove();
  //document.querySelector("ytd-miniplayer-ui")?.remove();
      //if (window.location.pathname != "/watch") document.querySelector("#movie_player video")?.remove();
  //(Causes trouble if videos in queue)
}

function gen_aspect_fix() {
    "use strict";
    var vidfix = {
        inject: function(is_user_script) {
            var modules;
            var vidfix_api;
            var user_settings;
            var default_language;
            var send_settings_to_page;
            var receive_settings_from_page;
            modules = [];
            vidfix_api = {
                initializeBypasses: function() {
                    var ytd_watch;
                    var sizeBypass;
                    if (ytd_watch = document.querySelector("ytd-watch, ytd-watch-flexy")) {
                        sizeBypass = function() {
                            var width;
                            var height;
                            var movie_player;
                            if (!ytd_watch.theater && !document.querySelector(".iri-full-browser") && (movie_player = document.querySelector("#movie_player"))) {
                                width = movie_player.offsetWidth;
                                height = Math.round(movie_player.offsetWidth / (16 / 9));
                                if (ytd_watch.updateStyles) {
                                    ytd_watch.updateStyles({
                                        "--ytd-watch-flexy-width-ratio": 1,
                                        "--ytd-watch-flexy-height-ratio": 0.5625
                                    });
                                    ytd_watch.updateStyles({
                                        "--ytd-watch-width-ratio": 1,
                                        "--ytd-watch-height-ratio": 0.5625
                                    });
                                }
                            }
                            else {
                                width = window.NaN;
                                height = window.NaN;
                            }
                            return {
                                width: width,
                                height: height
                            };
                        };
                        if (ytd_watch.calculateCurrentPlayerSize_) {
                            if (!ytd_watch.calculateCurrentPlayerSize_.bypassed) {
                                ytd_watch.calculateCurrentPlayerSize_ = sizeBypass;
                                ytd_watch.calculateCurrentPlayerSize_.bypassed = true;
                            }
                            if (!ytd_watch.calculateNormalPlayerSize_.bypassed) {
                                ytd_watch.calculateNormalPlayerSize_ = sizeBypass;
                                ytd_watch.calculateNormalPlayerSize_.bypassed = true;
                            }
                        }
                    }
                },
                initializeSettings: function(new_settings) {
                    var i;
                    var j;
                    var option;
                    var options;
                    var loaded_settings;
                    var vidfix_settings;
                    if (vidfix_settings = document.getElementById("vidfix-settings")) {
                        loaded_settings = JSON.parse(vidfix_settings.textContent || "null");
                        receive_settings_from_page = vidfix_settings.getAttribute("settings-beacon-from");
                        send_settings_to_page = vidfix_settings.getAttribute("settings-beacon-to");
                        vidfix_settings.remove();
                    }
                    user_settings = new_settings || loaded_settings || user_settings || {};
                    for (i = 0; i < modules.length; i++) {
                        for (options in modules[i].options) {
                            if (modules[i].options.hasOwnProperty(options)) {
                                option = modules[i].options[options];
                                if (!(option.id in user_settings) && "value" in option) {
                                    user_settings[option.id] = option.value;
                                }
                            }
                        }
                    }
                },
                initializeModulesUpdate: function() {
                    var i;
                    for (i = 0; i < modules.length; i++) {
                        if (modules[i].onSettingsUpdated) {
                            modules[i].onSettingsUpdated();
                        }
                    }
                },
                initializeModules: function() {
                    var i;
                    for (i = 0; i < modules.length; i++) {
                        if (modules[i].ini) {
                            modules[i].ini();
                        }
                    }
                },
                initializeOption: function() {
                    var key;
                    if (this.started) {
                        return true;
                    }
                    this.started = true;
                    for (key in this.options) {
                        if (this.options.hasOwnProperty(key)) {
                            if (!(key in user_settings) && this.options[key].value) {
                                user_settings[key] = this.options[key].value;
                            }
                        }
                    }
                    return false;
                },
                initializeBroadcast: function(event) {
                    if (event.data) {
                        if (event.data.type === "settings") {
                            if (event.data.payload) {
                                if (event.data.payload.broadcast_id === this.broadcast_channel.name) {
                                    this.initializeSettings(event.data.payload);
                                    this.initializeModulesUpdate();
                                }
                            }
                        }
                    }
                },
                ini: function() {
                    this.initializeSettings();
                    this.broadcast_channel = new BroadcastChannel(user_settings.broadcast_id);
                    this.broadcast_channel.addEventListener("message", this.initializeBroadcast.bind(this));
                    document.documentElement.addEventListener("load", this.initializeSettingsButton, true);
                    document.documentElement.addEventListener("load", this.initializeBypasses, true);
                    if (this.isSettingsPage) {
                        this.initializeModules();
                    }
                }
            };
            vidfix_api.ini();
        },
        isAllowedPage: function() {
            var current_page;
            if (current_page = window.location.pathname.match(/\/[a-z-]+/)) {
                current_page = current_page[0];
            }
            else {
                current_page = window.location.pathname;
            }
            return ["/tv", "/embed", "/live_chat", "/account", "/account_notifications", "/create_channel", "/dashboard", "/upload", "/webcam"].indexOf(current_page) < 0;
        },
        generateUUID: function() {
            return ([1e7] + -1e3 + -4e3 + -8e3 + -1e11)
                .replace(/[018]/g, function(point) {
                return (point ^ window.crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> point / 4)
                    .toString(16);
            });
        },
        saveSettings: function() {
            if (this.is_user_script) {
                this.GM.setValue(this.id, JSON.stringify(this.user_settings));
            }
            else {
                chrome.storage.local.set({
                    vidfixSettings: this.user_settings
                });
            }
        },
        updateSettingsOnOpenWindows: function() {
            this.broadcast_channel.postMessage({
                type: "settings",
                payload: this.user_settings
            });
        },
        settingsUpdatedFromOtherWindow: function(event) {
            if (event.data && event.data.broadcast_id === this.broadcast_channel.name) {
                this.user_settings = event.data;
                this.saveSettings();
            }
        },
        contentScriptMessages: function(custom_event) {
            var updated_settings;
            if ((updated_settings = custom_event.detail.settings) !== undefined) {
                this.saveSettings();
            }
        },
        initializeScript: function(event) {
            var holder;
            this.user_settings = event[this.id] || event;
            if (!this.user_settings.broadcast_id) {
                this.user_settings.broadcast_id = this.generateUUID();
                this.saveSettings();
            }
            this.broadcast_channel = new BroadcastChannel(this.user_settings.broadcast_id);
            this.broadcast_channel.addEventListener("message", this.settingsUpdatedFromOtherWindow.bind(this));
            event = JSON.stringify(this.user_settings);
            holder = document.createElement("vidfix-settings");
            holder.id = "vidfix-settings";
            holder.textContent = event;
            holder.setAttribute("style", "display: none");
            holder.setAttribute("settings-beacon-from", this.receive_settings_from_page);
            holder.setAttribute("settings-beacon-to", this.send_settings_to_page);
            document.documentElement.appendChild(holder);

            //Fixes chromium based browsers
            if ("trustedTypes" in window) {
                window.trustedTypes.createPolicy('default', {
                    createHTML: str => str,
                    createScriptURL: str=> str,
                    createScript: str=> str,
                });
            }
            GM_addElement('script', {
                textContent: "(" + this.inject + "(" + this.is_user_script.toString() + "))"
            });
            holder.remove();
            this.inject = null;
            delete this.inject;
        },
        main: function(event) {
            var now;
            var context;
            now = Date.now();
            this.receive_settings_from_page = now + "-" + this.generateUUID();
            this.send_settings_to_page = now + 1 + "-" + this.generateUUID();
            window.addEventListener(this.receive_settings_from_page, this.contentScriptMessages.bind(this), false);
            if (!event) {
                if (this.is_user_script) {
                    context = this;
                    // javascript promises are horrible
                    this.GM.getValue(this.id, "{}")
                        .then(function(value) {
                        event = JSON.parse(value);
                        context.initializeScript(event);
                    });
                }
            }
            else {
                this.initializeScript(event);
            }
        },
        ini: function() {
            if (this.isAllowedPage()) {
                this.is_settings_page = window.location.pathname === "/vidfix-settings";
                this.id = "vidfixSettings";
                if (typeof GM === "object" || typeof GM_info === "object") {
                    this.is_user_script = true;
                    // GreaseMonkey 4 polly fill
                    // https://arantius.com/misc/greasemonkey/imports/greasemonkey4-polyfill.js
                    if (typeof GM === "undefined") {
                        this.GM = {
                            setValue: GM_setValue,
                            info: GM_info,
                            getValue: function() {
                                return new Promise((resolve, reject) => {
                                    try {
                                        resolve(GM_getValue.apply(this, arguments));
                                    }
                                    catch (e) {
                                        reject(e);
                                    }
                                });
                            }
                        };
                    }
                    else {
                        this.GM = GM;
                    }
                    this.main();
                }
                else {
                    this.is_user_script = false;
                    chrome.storage.local.get(this.id, this.main.bind(this));
                }
            }
        }
    };

    vidfix.ini();
}

function waitForElement(selector) {
    return new Promise(resolve => {
        const query = document.querySelector(selector);
        if (query) return resolve(query);
        const observer = new MutationObserver(mutations => {
            const query = document.querySelector(selector);
            if (query) {
                resolve(query);
                observer.disconnect();
            }
        });
        observer.observe(document, {
            childList: true,
            subtree: true
        });
    });
}

function gen_history() {
    /*
     - Grey out watched video thumbnails info:
     - Use ALT+LeftClick or ALT+RightClick on a video list item to manually toggle the watched marker. The mouse button is defined in the script and can be changed.
     - For restoring/merging history, source file can also be a YouTube's history data JSON (downloadable from https://support.google.com/accounts/answer/3024190?hl=en). Or a list of YouTube video URLs (using current time as timestamps).
   */
    //=== config start ===
    var maxWatchedVideoAge   = 5 * 365; //number of days. set to zero to disable (not recommended)
    var contentLoadMarkDelay = 600;     //number of milliseconds to wait before marking video items on content load phase (increase if slow network/browser)
    var markerMouseButtons   = [0, 1];  //one or more mouse buttons to use for manual marker toggle. 0=left, 1=right, 2=middle. e.g.:
    //if `[0]`, only left button is used, which is ALT+LeftClick.
    //if `[1]`, only right button is used, which is ALT+RightClick.
    //if `[0,1]`, any left or right button can be used, which is: ALT+LeftClick or ALT+RightClick.
    //=== config end ===

    var watchedVideos, ageMultiplier = 24 * 60 * 60 * 1000, xu = /(?:\/watch(?:\?|.*?&)v=|\/embed\/)([^\/\?&]+)|\/shorts\/([^\/\?]+)/,
    querySelector = Element.prototype.querySelector, querySelectorAll = Element.prototype.querySelectorAll;
    function getVideoId(url) {
        var vid = url.match(xu);
        if (vid) vid = vid[1] || vid[2];
        return vid;
    }

    function watched(vid) {
        return !!watchedVideos.entries[vid];
    }

    function processVideoItems(selector) {
        var items = document.querySelectorAll(selector), i, link;
        for (i = items.length-1; i >= 0; i--) {
            if (link = querySelector.call(items[i], "A")) {
                if (watched(getVideoId(link.href))) {
                    items[i].classList.add("watched");
                } else items[i].classList.remove("watched");
            }
        }
    }

  function processAllVideoItems() {
    //home page
    processVideoItems(`.yt-uix-shelfslider-list>.yt-shelf-grid-item`);
    processVideoItems(`#contents.ytd-rich-grid-renderer>ytd-rich-item-renderer, #contents.ytd-rich-shelf-renderer ytd-rich-item-renderer.ytd-rich-shelf-renderer, #contents.ytd-rich-grid-renderer>ytd-rich-grid-row ytd-rich-grid-media`);
    //subscriptions page
    processVideoItems(`.multirow-shelf>.shelf-content>.yt-shelf-grid-item`);
    //history:watch page
    processVideoItems(`ytd-section-list-renderer[page-subtype="history"] .ytd-item-section-renderer>ytd-video-renderer`);
    //channel/user home page
    processVideoItems(`#contents>.ytd-item-section-renderer>.ytd-newspaper-renderer, #items>.yt-horizontal-list-renderer`); //old
    processVideoItems(`#contents>.ytd-channel-featured-content-renderer, #contents>.ytd-shelf-renderer>#grid-container>.ytd-expanded-shelf-contents-renderer`); //new
    //channel/user video page
    processVideoItems(`.yt-uix-slider-list>.featured-content-item, .channels-browse-content-grid>.channels-content-item, #items>.ytd-grid-renderer, #contents>.ytd-rich-grid-renderer`);
    //channel/user shorts page
    processVideoItems(`ytd-rich-item-renderer ytd-rich-grid-slim-media`);
    //channel/user playlist page
    processVideoItems(`.expanded-shelf>.expanded-shelf-content-list>.expanded-shelf-content-item-wrapper, .ytd-playlist-video-renderer`);
    //channel/user playlist item page
    processVideoItems(`.pl-video-list .pl-video-table .pl-video, ytd-playlist-panel-video-renderer`);
    //channel/user search page
    if (/^\/(?:(?:c|channel|user)\/)?.*?\/search/.test(location.pathname)) {
    processVideoItems(`.ytd-browse #contents>.ytd-item-section-renderer`); //new
    }
    //search page
    processVideoItems(`#results>.section-list .item-section>li, #browse-items-primary>.browse-list-item-container`); //old
    processVideoItems(`.ytd-search #contents>ytd-video-renderer, .ytd-search #contents>ytd-playlist-renderer, .ytd-search #items>ytd-video-renderer`); //new
    //video page
    processVideoItems(`.watch-sidebar-body>.video-list>.video-list-item, .playlist-videos-container>.playlist-videos-list>li`); //old
    processVideoItems(`.ytd-compact-video-renderer, .ytd-compact-radio-renderer, ytd-watch-next-secondary-results-renderer .yt-lockup-view-model-wiz`); //new
    processVideoItems(`.ytd-item-section-renderer .lockup`); //new
  }

    function addHistory(vid, time, noSave, i) {
        if (!watchedVideos.entries[vid]) {
            watchedVideos.index.push(vid);
        } else {
            i = watchedVideos.index.indexOf(vid);
            if (i >= 0) watchedVideos.index.push(watchedVideos.index.splice(i, 1)[0])
        }
        watchedVideos.entries[vid] = time;
        if (!noSave) GM_setValue("watchedVideos", JSON.stringify(watchedVideos));
    }

    function delHistory(index, noSave) {
        delete watchedVideos.entries[watchedVideos.index[index]];
        watchedVideos.index.splice(index, 1);
        if (!noSave) GM_setValue("watchedVideos", JSON.stringify(watchedVideos));
    }

    var dc, ut;
    function parseData(s, a, i, j, z) {
        try {
            dc = false;
            s = JSON.parse(s);
            //convert to new format if old format.
            //old: [{id:<strVID>, timestamp:<numDate>}, ...]
            //new: {entries:{<stdVID>:<numDate>, ...}, index:[<strVID>, ...]}
            if (Array.isArray(s) && (!s.length || (("object" === typeof s[0]) && s[0].id && s[0].timestamp))) {
                a = s;
                s = {entries: {}, index: []};
                a.forEach(o => {
                    s.entries[o.id] = o.timestamp;
                    s.index.push(o.id);
                });
            } else if (("object" !== typeof s) || ("object" !== typeof s.entries) || !Array.isArray(s.index)) return null;
            //reconstruct index if broken
            if (s.index.length !== (a = Object.keys(s.entries)).length) {
                s.index = a.map(k => [k, s.entries[k]]).sort((x, y) => x[1] - y[1]).map(v => v[0]);
                dc = true;
            }
            return s;
        } catch(z) {
            return null;
        }
    }

    function parseYouTubeData(s, a) {
        try {
            s = JSON.parse(s);
            //convert to native format if YouTube format.
            //old: [{titleUrl:<strUrl>, time:<strIsoDate>}, ...] (excludes irrelevant properties)
            //new: {entries:{<stdVID>:<numDate>, ...}, index:[<strVID>, ...]}
            if (Array.isArray(s) && (!s.length || (("object" === typeof s[0]) && s[0].titleUrl && s[0].time))) {
                a = s;
                s = {entries: {}, index: []};
                a.forEach((o, m, t) => {
                    if (o.titleUrl && (m = o.titleUrl.match(xu))) {
                        if (isNaN(t = (new Date(o.time)).getTime())) t = (new Date()).getTime();
                        s.entries[m[1] || m[2]] = t;
                        s.index.push(m[1] || m[2]);
                    }
                });
                s.index.reverse();
                return s;
            } else return null;
        } catch(a) {
            return null;
        }
    }

    function mergeData(o, a) {
        o.index.forEach(i => {
            if (watchedVideos.entries[i]) {
                if (watchedVideos.entries[i] < o.entries[i]) watchedVideos.entries[i] = o.entries[i];
            } else watchedVideos.entries[i] = o.entries[i];
        });
        a = Object.keys(watchedVideos.entries);
        watchedVideos.index = a.map(k => [k, watchedVideos.entries[k]]).sort((x, y) => x[1] - y[1]).map(v => v[0]);
    }

    function getHistory(a, b) {
        a = GM_getValue("watchedVideos");
        if (a === undefined) {
            a = '{"entries": {}, "index": []}';
        } else if ("object" === typeof a) a = JSON.stringify(a);
        if (b = parseData(a)) {
            watchedVideos = b;
            if (dc) b = JSON.stringify(b);
        } else b = JSON.stringify(watchedVideos = {entries: {}, index: []});
        GM_setValue("watchedVideos", b);
    }

    function doProcessPage() {
        //get list of watched videos
        getHistory();

        //remove old watched video history
        var now = (new Date()).valueOf(), changed, vid;
        if (maxWatchedVideoAge > 0) {
            while (watchedVideos.index.length) {
                if (((now - watchedVideos.entries[watchedVideos.index[0]]) / ageMultiplier) > maxWatchedVideoAge) {
                    delHistory(0, false);
                    changed = true;
                } else break;
            }
            if (changed) GM_setValue("watchedVideos", JSON.stringify(watchedVideos));
        }

        //check and remember current video
        if ((vid = getVideoId(location.href)) && !watched(vid)) addHistory(vid, now);

        //mark watched videos
        processAllVideoItems();
    }
    function processPage() {
        setTimeout(doProcessPage, Math.floor(contentLoadMarkDelay / 2));
    }

    function delayedProcessPage() {
        setTimeout(doProcessPage, contentLoadMarkDelay);
    }

  function toggleMarker(ele, i) {
    if (ele) {
      if (!ele.href && (i = ele.closest('a'))) ele = i;
      if (ele.href) {
        i = getVideoId(ele.href);
      } else {
        while (ele) {
          while (ele && (!ele.__data || !ele.__data.data || !ele.__data.data.videoId)) ele = ele.__dataHost || ele.parentNode;
          if (ele) {
            i = ele.__data.data.videoId;
            break
          }
        }
      }
      if (i) {
        if ((ele = watchedVideos.index.indexOf(i)) >= 0) {
          delHistory(ele);
        } else addHistory(i, (new Date()).valueOf());
        processAllVideoItems();
      }
    }
  }

    var rxListUrl = /\/\w+_ajax\?|\/results\?search_query|\/v1\/(browse|next|search)\?/;
    var xhropen = XMLHttpRequest.prototype.open, xhrsend = XMLHttpRequest.prototype.send;
    XMLHttpRequest.prototype.open = function(method, url) {
        this.url_mwyv = url;
        return xhropen.apply(this, arguments);
    };
    XMLHttpRequest.prototype.send = function(method, url) {
        if (rxListUrl.test(this.url_mwyv) && !this.listened_mwyv) {
            this.listened_mwyv = 1;
            this.addEventListener("load", delayedProcessPage);
        }
        return xhrsend.apply(this, arguments);
    };

    var fetch_ = unsafeWindow.fetch;
    unsafeWindow.fetch = function(opt) {
        let url = opt.url || opt;
        if (rxListUrl.test(opt.url || opt)) {
            return fetch_.apply(this, arguments).finally(delayedProcessPage);
        } else return fetch_.apply(this, arguments);
    };
  var nac = unsafeWindow.Node.prototype.appendChild;
  unsafeWindow.Node.prototype.appendChild = function(e) {
    var z;
    if ((this.tagName === "BODY") && (e?.tagName === "IFRAME")) {
      var r = nac.apply(this, arguments);
      try {
        if (/^about:blank\b/.test(e.contentWindow.location.href)) e.contentWindow.fetch = fetch
      } catch(z) {}
      return r
    } else return nac.apply(this, arguments)
  }
  var to = {createHTML: s => s}, tp = window.trustedTypes?.createPolicy ? trustedTypes.createPolicy("", to) : to, html = s => tp.createHTML(s);

    addEventListener("DOMContentLoaded", sty => {
        sty = document.createElement("STYLE");
        sty.innerHTML = html(`

`);
        document.head.appendChild(sty);
        var nde = Node.prototype.dispatchEvent;
        Node.prototype.dispatchEvent = function(ev) {
            if (ev.type === "yt-service-request-completed") {
                clearTimeout(ut);
                ut = setTimeout(doProcessPage, contentLoadMarkDelay / 2)
            }
            return nde.apply(this, arguments)
        };
    });

    var lastFocusState = document.hasFocus();
    addEventListener("blur", () => {
        lastFocusState = false;
    });
    addEventListener("focus", () => {
        if (!lastFocusState) processPage();
        lastFocusState = true;
    });
    addEventListener("click", (ev) => {
    if ((markerMouseButtons.indexOf(ev.button) >= 0) && ev.altKey) {
      ev.stopImmediatePropagation();
      ev.stopPropagation();
      ev.preventDefault();
      toggleMarker(ev.target);
    }
  }, true);

    if (markerMouseButtons.indexOf(1) >= 0) {
        addEventListener("contextmenu", (ev) => {
            if (ev.altKey) toggleMarker(ev.target);
        });
    }
    if (window["body-container"]) { //old
        addEventListener("spfdone", processPage);
        processPage();
    } else { //new
        var t = 0;
        function pl() {
            clearTimeout(t);
            t = setTimeout(processPage, 300);
        }
        (function init(vm) {
            if (vm = document.getElementById("visibility-monitor")) {
                vm.addEventListener("viewport-load", pl);
            } else setTimeout(init, 100);
        })();
        (function init2(mh) {
            if (mh = document.getElementById("masthead")) {
                mh.addEventListener("yt-rendererstamper-finished", pl);
            } else setTimeout(init2, 100);
        })();
        addEventListener("load", delayedProcessPage);
        addEventListener("spfprocess", delayedProcessPage);
    }

    GM_registerMenuCommand("Display History Statistics", () => {
        function sum(r, v) {
            return r + v;
        }
        function avg(arr) {
            return arr && arr.length ? Math.round(arr.reduce(sum, 0) / arr.length) : "(n/a)";
        }
        var pd, pm, py, ld = [], lm = [], ly = [];
        getHistory();
        Object.keys(watchedVideos.entries).forEach((k, t) => {
            t = new Date(watchedVideos.entries[k]);
            if (!pd || (pd !== t.getDate())) {
                ld.push(1);
                pd = t.getDate();
            } else ld[ld.length - 1]++;
            if (!pm || (pm !== (t.getMonth() + 1))) {
                lm.push(1);
                pm = t.getMonth() + 1;
            } else lm[lm.length - 1]++;
            if (!py || (py !== t.getFullYear())) {
                ly.push(1);
                py = t.getFullYear();
            } else ly[ly.length - 1]++;
        });
        if (watchedVideos.index.length) {
            pd = (new Date(watchedVideos.entries[watchedVideos.index[0]])).toLocaleString();
            pm = (new Date(watchedVideos.entries[watchedVideos.index[watchedVideos.index.length - 1]])).toLocaleString();
        } else {
            pd = "(n/a)";
            pm = "(n/a)";
        }
        alert(`\
Number of entries: ${watchedVideos.index.length}
Oldest entry: ${pd}
Newest entry: ${pm}

Average viewed videos per day: ${avg(ld)}
Average viewed videos per month: ${avg(lm)}
Average viewed videos per year: ${avg(ly)}

History data size: ${JSON.stringify(watchedVideos).length} bytes\
`);
  });

    GM_registerMenuCommand("Backup History Data", (a, b) => {
        document.body.appendChild(a = document.createElement("A")).href = URL.createObjectURL(new Blob([JSON.stringify(watchedVideos)], {type: "application/json"}));
        a.download = `MarkWatchedYouTubeVideos_${(new Date()).toISOString()}.json`;
        a.click();
        a.remove();
        URL.revokeObjectURL(a.href);
    });

    GM_registerMenuCommand("Restore History Data", (a, b) => {
        function askRestore(o) {
            if (confirm(`Selected history data file contains ${o.index.length} entries.\n\nRestore from this data?`)) {
                if (mwyvrhm_ujs.checked) {
                    mergeData(o);
                } else watchedVideos = o;
                GM_setValue("watchedVideos", JSON.stringify(watchedVideos));
                a.remove();
                doProcessPage();
            }
        }
        if (window.mwyvrh_ujs) return;
        (a = document.createElement("DIV")).id = "mwyvrh_ujs";
        a.innerHTML = html(`<style>
       #mwyvrh_ujs {display:flex;position:fixed;z-index:99999;left:0;top:0;right:0;bottom:0;margin:0;border:none;padding:0;background:rgb(0,0,0,0.5);color:#000;font-family:sans-serif;font-size:12pt;line-height:12pt;font-weight:normal;cursor:pointer}
       #mwyvrhb_ujs {margin:auto;border:.3rem solid #007;border-radius:.3rem;padding:.5rem .5em;background-color:#fff;cursor:auto}
       #mwyvrht_ujs {margin-bottom:1rem;font-size:14pt;line-height:14pt;font-weight:bold}
       #mwyvrhmc_ujs {margin:.5em 0 1em 0;text-align:center}
       #mwyvrhi_ujs {display:block;margin:1rem auto .5rem auto;overflow:hidden}
       </style>
<div id="mwyvrhb_ujs">
  <div id="mwyvrht_ujs">Mark Watched YouTube Videos</div>
  Please select a file to restore history data from.
  <div id="mwyvrhmc_ujs"><label><input id="mwyvrhm_ujs" type="checkbox" checked /> Merge history data instead of replace.</label></div>
  <input id="mwyvrhi_ujs" type="file" multiple />
</div>`);
        a.onclick = e => {
            (e.target === a) && a.remove();
        };
        (b = a.querySelector("#mwyvrhi_ujs")).onchange = r => {
            r = new FileReader();
            r.onload = (o, t) => {
                if (o = parseData(r = r.result)) { //parse as native format
                    if (o.index.length) {
                        askRestore(o);
                    } else alert("File doesn't contain any history entry.");
                } else if (o = parseYouTubeData(r)) { //parse as YouTube format
                    if (o.index.length) {
                        askRestore(o);
                    } else alert("File doesn't contain any history entry.");
                } else { //parse as URL list
                    o = {entries: {}, index: []};
                    t = (new Date()).getTime();
                    r = r.replace(/\r/g, "").split("\n");
                    while (r.length && !r[0].trim()) r.shift();
                    if (r.length && xu.test(r[0])) {
                        r.forEach(s => {
                            if (s = s.match(xu)) {
                                o.entries[s[1] || s[2]] = t;
                                o.index.push(s[1] || s[2]);
                            }
                        });
                        if (o.index.length) {
                            askRestore(o);
                        } else alert("File doesn't contain any history entry.");
                    } else alert("Invalid history data file.");
                }
            };
            r.readAsText(b.files[0]);
        };
        document.documentElement.appendChild(a);
        b.click();
    });
}

function counterstuff() {
    function replaceCountersText(elm) {
        const renderer = elm.parentNode.renderer;
        const count = renderer?.data?.viewCountText?.simpleText ?? renderer?.data?.content?.videoRenderer?.viewCountText?.simpleText;
        if (count && elm.textContent != count)
            elm.textContent = count;
    }

    const counterObserver = new MutationObserver(mutations => mutations.filter(m => m.type == "characterData").forEach(m => replaceCountersText(m.target)));
    // this observer disables the like count updating while watching a live stream because it messes with a bunch of things and we can't get full like count from it either
    const likeObserver = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            while (mutation.target.childNodes.length > 1) {
                mutation.target.removeChild(mutation.target.lastChild);
            }
        });
    });

    function replaceCountersEach(elm) {
        elm.setAttribute("patched7kt", "");
        const counters = elm.querySelectorAll("#metadata-line span");
        if (counters.length != 2)
            return;
        counters[0].renderer = elm;
        replaceCountersText(counters[0].firstChild);
        counterObserver.observe(counters[0], { subtree: true, characterData: true });
    }

    function replaceCommentCounter(elm) {
        elm.setAttribute("patched7kt", "");
        const voteCount = elm.querySelector("#vote-count-middle");
        if (!isNaN(voteCount.innerText))
            return;
        const fullCount = parseInt(elm.querySelector("#like-button button").getAttribute("aria-label").match(/\d/g).join(""));
        voteCount.innerText = fullCount;
    }

    setInterval (function() {
        document.querySelectorAll('ytd-compact-video-renderer:not([patched7kt])').forEach(replaceCountersEach);
        document.querySelectorAll('ytd-grid-video-renderer:not([patched7kt])').forEach(replaceCountersEach);
        document.querySelectorAll('ytd-rich-item-renderer:not([patched7kt])').forEach(replaceCountersEach);
        document.querySelectorAll('ytd-video-renderer:not([patched7kt])').forEach(replaceCountersEach);
        document.querySelectorAll('ytd-comment-renderer:not([patched7kt])').forEach(replaceCommentCounter);
    }, 1000);

    waitForElement("#info #segmented-like-button #text").then(elm => likeObserver.observe(elm, { childList: true, subtree: true }));
}

waitForElement('ytd-compact-link-renderer').then(function(elm) {
    const link = document.querySelector('#container yt-multi-page-menu-section-renderer:nth-child(2) ytd-compact-link-renderer:nth-child(4)');
    if (link !== null)
        document.querySelector('#container yt-multi-page-menu-section-renderer:nth-child(2) ytd-compact-link-renderer:nth-child(4)').style.left = document.querySelector('[menu-style="multi-page-menu-style-type-system"] #container yt-multi-page-menu-section-renderer:first-child ytd-compact-link-renderer:nth-child(3) a').offsetWidth+"px";
});

function restoreDropdown(iconLabel, firstChild, dropdownChildren) {
    const iconLabelSel = document.querySelector(iconLabel);
    if (!window.location.search.includes("sort")) // channel sort dropdown fix
        iconLabelSel.innerHTML = document.querySelector(firstChild)?.innerHTML;

    for (const x of document.querySelectorAll(dropdownChildren)) {
        x.addEventListener("click", function() {
            iconLabelSel.innerHTML = this.innerHTML;
        }, false);
    }
}

async function setupUpdateDependentElements(e) {
    if (e.detail.pageType == "watch") {
        waitForElement('#top-row.ytd-video-secondary-info-renderer').then(setupSecondaryInfoRenderer);
        waitForElement('#messages').then((elm) => viewCount(elm));
        //waitForElement('yt-formatted-string#info.style-scope.ytd-watch-info-text').then((elm) => setUploadedText(elm));
        // classic description
        var description;
        waitForElement('tp-yt-paper-button[id="more"]').then((elm) => elm.addEventListener("click", () => description.removeAttribute("collapsed")));
        waitForElement('ytd-expander.ytd-video-secondary-info-renderer').then((elm) => { description = elm });
        waitForElement('ytd-engagement-panel-section-list-renderer[target-id="engagement-panel-structured-description"]').then((elm) => elm?.remove());

        waitForElement("ytd-menu-popup-renderer tp-yt-paper-listbox").then(function(elm) {
            const saveBtn = [...elm.children].find(item => item.__data.icon == "yt-icons:playlist_add");
            saveBtn.classList.add("addto-btn");
        });
    }

    if (/home|trending|subscriptions/.test(e.detail.pageType)) {
        waitForElement("#endpoint.ytd-guide-entry-renderer[href^='/feed/trending'] yt-formatted-string").then(createNavBar);
        document.querySelector("[hidden] .ytcp-main-appbar")?.remove();
    }

    waitForElement("ytd-comments-header-renderer yt-dropdown-menu:last-of-type").then(function() {
        restoreDropdown("ytd-comments-header-renderer #icon-label.yt-dropdown-menu",
                        "ytd-comments-header-renderer a.yt-dropdown-menu:first-child > tp-yt-paper-item:first-child > tp-yt-paper-item-body:first-child > div:first-child",
                        "ytd-comments-header-renderer a.yt-dropdown-menu > tp-yt-paper-item:first-child > tp-yt-paper-item-body:first-child > div:first-child");
    });

    waitForElement("yt-sort-filter-sub-menu-renderer yt-dropdown-menu:last-of-type").then(function() {
        restoreDropdown("yt-sort-filter-sub-menu-renderer #icon-label.yt-dropdown-menu",
                        "yt-sort-filter-sub-menu-renderer a.yt-dropdown-menu:nth-child(3) > tp-yt-paper-item:first-child > tp-yt-paper-item-body:first-child > div:first-child",
                        "yt-sort-filter-sub-menu-renderer a.yt-dropdown-menu > tp-yt-paper-item:first-child > tp-yt-paper-item-body:first-child > div:first-child");
    });

    // remove ambient mode player menu item
    waitForElement("path[d='M21 7v10H3V7h18m1-1H2v12h20V6zM11.5 2v3h1V2h-1zm1 17h-1v3h1v-3zM3.79 3 6 5.21l.71-.71L4.5 2.29 3.79 3zm2.92 16.5L6 18.79 3.79 21l.71.71 2.21-2.21zM19.5 2.29 17.29 4.5l.71.71L20.21 3l-.71-.71zm0 19.42.71-.71L18 18.79l-.71.71 2.21 2.21z']")
        .then(elm => elm.closest(".ytp-menuitem").remove());
}
    window.addEventListener("yt-page-data-updated", removePlayerElements, false);

// init functions
genSettings();
patch_css();
gen_history();
gen_aspect_fix();
//subbutton();
counterstuff();
tempcssfix();
patch_player_ui();
