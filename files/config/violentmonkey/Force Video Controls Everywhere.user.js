// ==UserScript==
// @name         Force Video Controls Everywhere
// @namespace    http://tampermonkey.net/
// @version      1.1
// @description  Force native video controls to always be visible on all sites
// @author       You
// @match        *://*/*
// @grant        none
// @run-at       document-start
// @exclude      https://www.youtube.com/*
// @exclude      *://www.youtube.com/*
// @exclude      *://music.youtube.com/*
// ==/UserScript==

(function () {
  'use strict';

  function forceControls(video) {
    video.controls = true;
    video.setAttribute('controls', '');
    // Prevent sites from removing controls
    const observer = new MutationObserver(() => {
      if (!video.hasAttribute('controls')) {
        video.controls = true;
        video.setAttribute('controls', '');
      }
    });
    observer.observe(video, { attributes: true, attributeFilter: ['controls'] });
  }

  function scanAndForce() {
    document.querySelectorAll('video').forEach(forceControls);
  }

  // Handle videos already in the DOM
  scanAndForce();

  // Handle dynamically added videos (e.g. Reddit's lazy-loaded posts)
  const domObserver = new MutationObserver((mutations) => {
    for (const mutation of mutations) {
      for (const node of mutation.addedNodes) {
        if (node.nodeName === 'VIDEO') forceControls(node);
        if (node.querySelectorAll) node.querySelectorAll('video').forEach(forceControls);
      }
    }
  });

  domObserver.observe(document.documentElement, { childList: true, subtree: true });
})();