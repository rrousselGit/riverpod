import React, {
  forwardRef,
  useEffect,
  useImperativeHandle,
  useRef,
  useState,
} from "react";
import useBaseUrl from "@docusaurus/useBaseUrl";

// Must match website/demos/bridge.dart.
const COMMAND_EVENT = "riverpod-demo:command";
const REPORT_EVENT = "riverpod-demo:event";

/** A report sent by a demo, through `DemoBridge.emit`. */
export type DemoReport = { type: string; data?: unknown };

export type FlutterEmbedHandle = {
  /** Sends a command to the demo, received by `DemoBridge.listen`. */
  send(type: string, value?: unknown): void;
};

type FlutterApp = {
  addView(options: { hostElement: HTMLElement; initialData?: unknown }): number;
  removeView(viewId: number): void;
};

declare global {
  interface Window {
    riverpodDemos?: Promise<FlutterApp>;
  }
}

let appPromise: Promise<FlutterApp> | undefined;

/**
 * Loads the Flutter demos (built by `npm run build:demos`) once per page load.
 * Every embed then adds its own view to that single app.
 */
function loadApp(bootstrapUrl: string): Promise<FlutterApp> {
  appPromise ??= new Promise<void>((resolve, reject) => {
    const script = document.createElement("script");
    script.src = bootstrapUrl;
    script.async = true;
    script.onload = () => resolve();
    script.onerror = () =>
      reject(new Error(`Failed to load ${bootstrapUrl}. Run: npm run build:demos`));
    document.body.appendChild(script);
  }).then(() => window.riverpodDemos!);

  // Allow retrying after a failure.
  appPromise.catch(() => (appPromise = undefined));
  return appPromise;
}

/** The fake phone's status bar, purely decorative. */
function StatusBar() {
  return (
    <div className="flutter-embed__status-bar" aria-hidden>
      <span>9:41</span>
      <span className="flutter-embed__island" />
      <svg viewBox="0 0 54 12" width="54" height="12" fill="currentColor">
        {/* Signal */}
        <rect x="0" y="8" width="3" height="4" rx="1" />
        <rect x="4.5" y="6" width="3" height="6" rx="1" />
        <rect x="9" y="3.5" width="3" height="8.5" rx="1" />
        <rect x="13.5" y="1" width="3" height="11" rx="1" />
        {/* Wi-Fi */}
        <path d="M28 12l-2.4-2.6a3.4 3.4 0 014.8 0zM23.6 7.3a6.3 6.3 0 018.8 0l-1.3 1.4a4.4 4.4 0 00-6.2 0zM21.4 5a9.4 9.4 0 0113.2 0l-1.3 1.4a7.5 7.5 0 00-10.6 0z" />
        {/* Battery */}
        <rect x="38.5" y="1.5" width="13" height="9" rx="2.5" fill="none" stroke="currentColor" strokeOpacity="0.4" />
        <rect x="40" y="3" width="10" height="6" rx="1.5" />
        <path d="M52.5 4.5v3a1.5 1.5 0 000-3z" fillOpacity="0.4" />
      </svg>
    </div>
  );
}

type FlutterEmbedProps = {
  /** A key of `demos` in website/demos/main.dart. */
  demo: string;
  /** Shown until the reader starts the demo. */
  poster: string;
  alt: string;
  width?: number;
  height?: number;
  /** Called once the demo is running and can receive commands. */
  onStart?: () => void;
  onReport?: (report: DemoReport) => void;
};

/**
 * Embeds a live Flutter app, from website/demos.
 *
 * The app is only downloaded once the reader clicks the poster.
 * Pages can drive the app with `ref.current.send(...)`, and observe it
 * with `onReport`.
 */
export const FlutterEmbed = forwardRef<FlutterEmbedHandle, FlutterEmbedProps>(
  function FlutterEmbed(props, ref) {
    const { demo, poster, alt, width = 340, height = 680 } = props;
    const bootstrapUrl = useBaseUrl("/flutter/flutter_bootstrap.js");
    const hostRef = useRef<HTMLDivElement>(null);
    const [status, setStatus] = useState<
      "idle" | "loading" | "running" | "error"
    >("idle");
    const [error, setError] = useState<string>();

    // Read through refs, so that callers don't need to memoize them.
    const onReport = useRef(props.onReport);
    onReport.current = props.onReport;
    const onStart = useRef(props.onStart);
    onStart.current = props.onStart;

    useImperativeHandle(ref, () => ({
      send(type, value) {
        hostRef.current?.dispatchEvent(
          new CustomEvent(COMMAND_EVENT, { detail: { type, value } })
        );
      },
    }));

    useEffect(() => {
      if (status !== "loading" && status !== "running") return;
      const host = hostRef.current!;

      const listener = (event: Event) => {
        const report = (event as CustomEvent<DemoReport>).detail;
        // Sent by website/demos/main.dart once the demo listens to commands.
        if (report.type === "ready") {
          setStatus("running");
          onStart.current?.();
        } else {
          onReport.current?.(report);
        }
      };
      host.addEventListener(REPORT_EVENT, listener);

      let disposed = false;
      let removeView: (() => void) | undefined;
      loadApp(bootstrapUrl).then(
        (app) => {
          if (disposed) return;
          const viewId = app.addView({ hostElement: host, initialData: { demo } });
          removeView = () => app.removeView(viewId);
        },
        (err: unknown) => {
          if (disposed) return;
          setError(String(err));
          setStatus("error");
        }
      );

      return () => {
        disposed = true;
        removeView?.();
        host.removeEventListener(REPORT_EVENT, listener);
      };
      // Re-running when status goes from "loading" to "running" would
      // remove the view, so only depend on whether the demo was started.
    },[status === "idle" || status === "error", demo, bootstrapUrl]);

    const started = status === "loading" || status === "running";

    return (
      <div className="flutter-embed">
        <div className="flutter-embed__screen" style={{ width, height }}>
          <StatusBar />
          <div className="flutter-embed__viewport">
            <div
              ref={hostRef}
              className="flutter-embed__host"
              style={{ display: started ? "block" : "none" }}
            />
            {status !== "running" && (
              <div className="flutter-embed__poster">
                <img src={poster} alt={alt} />
                <button
                  className="flutter-embed__play button button--primary"
                  disabled={status === "loading"}
                  onClick={() => {
                    setError(undefined);
                    setStatus("loading");
                  }}
                >
                  {status === "loading" ? "Loading…" : "▶ Run live demo"}
                </button>
                {error && <p className="flutter-embed__error">{error}</p>}
              </div>
            )}
          </div>
          <div className="flutter-embed__home-indicator" />
        </div>
      </div>
    );
  }
);
