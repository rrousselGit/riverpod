import React, { useRef, useState } from "react";
import useBaseUrl from "@docusaurus/useBaseUrl";
import { DemoReport, FlutterEmbed, FlutterEmbedHandle } from ".";

// Must match the reports of website/demos/pull_to_refresh.dart.
type ActivityState = {
  kind: "AsyncData" | "AsyncError" | "AsyncLoading";
  isLoading: boolean;
  isRefreshing: boolean;
  value: string | null;
  error: string | null;
};

type LogEntry = { id: number; time: string; message: string };

function describeState(state: ActivityState) {
  const fields = [
    state.value !== null && `value: '${state.value}'`,
    state.error !== null && `error: ${state.error}`,
    `isLoading: ${state.isLoading}`,
    `isRefreshing: ${state.isRefreshing}`,
  ].filter(Boolean);
  return `${state.kind}(${fields.join(", ")})`;
}

/**
 * The live version of the "Implementing pull-to-refresh" app,
 * with controls to change its fake network.
 */
export function PullToRefreshDemo() {
  const embed = useRef<FlutterEmbedHandle>(null);
  const [running, setRunning] = useState(false);
  const [latency, setLatency] = useState(1000);
  const [shouldFail, setShouldFail] = useState(false);
  const [state, setState] = useState<ActivityState>();
  const [log, setLog] = useState<LogEntry[]>([]);
  const nextLogId = useRef(0);

  function addLog(message: string) {
    const time = new Date().toLocaleTimeString([], { hour12: false });
    const entry = { id: nextLogId.current++, time, message };
    setLog((log) => [entry, ...log].slice(0, 50));
  }

  function onReport({ type, data }: DemoReport) {
    switch (type) {
      case "state": {
        const state = data as ActivityState;
        setState(state);
        addLog(describeState(state));
        break;
      }
      case "request": {
        const { id, status } = data as { id: number; status: string };
        addLog(`Request #${id} ${status}`);
        break;
      }
    }
  }

  return (
    <div className="flutter-demo">
      <FlutterEmbed
        ref={embed}
        demo="pull_to_refresh"
        poster={useBaseUrl("/img/how_to/pull_to_refresh/app.gif")}
        alt="A gif of the previously described application working"
        onReport={onReport}
        onStart={() => {
          // Sync controls changed before the demo started.
          embed.current!.send("setLatency", latency);
          embed.current!.send("setShouldFail", shouldFail);
          setRunning(true);
        }}
      />
      <div className="flutter-demo__panel">
        <p className="flutter-demo__hint">
          {running
            ? "Drag the list down inside the app to pull to refresh."
            : "Run the demo to try it, then play with its network below."}
        </p>
        <div className="flutter-demo__controls" aria-disabled={!running}>
          <label>
            Latency
            <input
              type="range"
              min={0}
              max={5000}
              step={250}
              value={latency}
              onChange={(e) => {
                const value = Number(e.target.value);
                setLatency(value);
                embed.current?.send("setLatency", value);
              }}
            />
            <code>{latency}ms</code>
          </label>
          <label>
            <input
              type="checkbox"
              checked={shouldFail}
              onChange={(e) => {
                setShouldFail(e.target.checked);
                embed.current?.send("setShouldFail", e.target.checked);
              }}
            />
            Make requests fail
          </label>
          <button
            className="button button--secondary button--sm"
            onClick={() => embed.current?.send("refresh")}
          >
            Call <code>ref.refresh(activityProvider)</code>
          </button>
        </div>
        {state && (
          <pre className="flutter-demo__state">{describeState(state)}</pre>
        )}
        <div className="flutter-demo__log-header">
          Log
          <button
            className="button button--link button--sm"
            onClick={() => setLog([])}
          >
            Clear
          </button>
        </div>
        <ul className="flutter-demo__log">
          {log.map((entry) => (
            <li key={entry.id}>
              {entry.time} {entry.message}
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}
