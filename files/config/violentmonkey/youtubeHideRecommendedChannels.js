// ==UserScript==
// @name         YouTube Remove Related Channels
// @match        https://www.youtube.com/*
// @run-at       document-idle
// ==/UserScript==

(function() {
    'use strict';

    function removeElements() {
        document
            .querySelectorAll('.branded-page-related-channels')
            .forEach(el => el.remove());
    }

    removeElements();

    new MutationObserver(removeElements).observe(document.body, {
        childList: true,
        subtree: true
    });
})();
