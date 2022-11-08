// ==UserScript==
// @name         CloseAfterLoad
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        *://*/*
// @grant        GM_openInTab
// @run-at document-start
// ==/UserScript==

(function() {
    'use strict';
    window.addEventListener('load', (event) => {
        setTimeout(function(){window.close();}, 5000);
    });

})();
