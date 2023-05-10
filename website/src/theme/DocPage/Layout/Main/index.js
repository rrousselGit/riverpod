import React from "react";
import clsx from "clsx";
import { useDocsSidebar } from "@docusaurus/theme-common/internal";
import styles from "./styles.module.css";
export default function DocPageLayoutMain({
  hiddenSidebarContainer,
  children,
}) {
  const sidebar = useDocsSidebar();
  return (
    <main
      className={clsx(
        styles.docMainContainer,
        (hiddenSidebarContainer || !sidebar) && styles.docMainContainerEnhanced
      )}
    >
      <div
        style={{
          width: "100%",
          backgroundColor: "var(--ifm-color-primary-dark)",
          color: "white",
          padding: 7,
        }}
      >
        <span
          style={{
            float: "left",
            marginRight: 20,
            marginLeft: 10,
          }}
        >
          ⚠️
        </span>
        The documentation for version 2.0 is in progress. A preview is available
        at:{" "}
        <a
          href="https://docs-v2.riverpod.dev/docs/introduction"
          style={{
            color: "white",
            textDecoration: "underline",
            display: "inline-block",
          }}
        >
          https://docs-v2.riverpod.dev
        </a>
      </div>
      <div
        className={clsx(
          "container padding-top--md padding-bottom--lg",
          styles.docItemWrapper,
          hiddenSidebarContainer && styles.docItemWrapperEnhanced
        )}
      >
        {children}
      </div>
    </main>
  );
}
