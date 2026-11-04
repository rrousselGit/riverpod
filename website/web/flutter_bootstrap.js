{{flutter_js}}
{{flutter_build_config}}

// Loads the demos in multi-view mode, and exposes the app as
// `window.riverpodDemos` (a Promise) so that the website can add one view per
// embedded demo. See src/components/FlutterEmbed.
(function () {
  // The directory this script is served from, such as "/flutter/".
  const base = new URL(".", document.currentScript.src).pathname;

  window.riverpodDemos = new Promise((resolve, reject) => {
    _flutter.loader
      .load({
        config: {
          entrypointBaseUrl: base,
          assetBase: base,
          canvasKitBaseUrl: base + "canvaskit/",
          suppressMultithreadingWarning: true,
        },
        onEntrypointLoaded: async (engineInitializer) => {
          try {
            const engine = await engineInitializer.initializeEngine({
              multiViewEnabled: true,
              assetBase: base,
              canvasKitBaseUrl: base + "canvaskit/",
            });
            resolve(await engine.runApp());
          } catch (error) {
            reject(error);
          }
        },
      })
      .catch(reject);
  });
})();
