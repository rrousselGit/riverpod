import React, { useContext } from "react";
import clsx from "clsx";
import { useThemeConfig } from "@docusaurus/theme-common";
import Logo from "@theme/Logo";
import CollapseButton from "@theme/DocSidebar/Desktop/CollapseButton";
import Content from "@theme/DocSidebar/Desktop/Content";
import styles from "./styles.module.css";
import { CodegenContext, FlutterHooksContext } from "../../DocPage/Layout";
import Translate, { translate } from "@docusaurus/Translate";
import "./toggle.scss";
import useIsBrowser from "@docusaurus/useIsBrowser";

function DocSidebarDesktop({ path, sidebar, onCollapse, isHidden }) {
  const {
    navbar: { hideOnScroll },
    docs: {
      sidebar: { hideable },
    },
  } = useThemeConfig();

  return (
    <div
      className={clsx(
        styles.sidebar,
        hideOnScroll && styles.sidebarWithHideableNavbar,
        isHidden && styles.sidebarHidden
      )}
    >
      <SidebarHead />

      {hideOnScroll && <Logo tabIndex={-1} className={styles.sidebarLogo} />}
      <Content path={path} sidebar={sidebar} />
      {hideable && <CollapseButton onClick={onCollapse} />}
    </div>
  );
}

export function SidebarHead({ direction }) {
  direction ??= "vertical";

  const [codegen, setCodegen] = useIsBrowser()
    ? useContext(CodegenContext)
    : [false, () => {}];
  const [flutterHooks, setFlutterHooks] = useIsBrowser()
    ? useContext(FlutterHooksContext)
    : [false, () => {}];

  return (
    <>
      <div
        className={styles.sidebar_head}
        style={{
          padding: "10px 10px 0 10px",
          display: "flex",
          alignItems: "end",
          flexDirection: direction === "horizontal" ? "row" : "column",
          justifyContent:
            direction === "horizontal" ? "space-evenly" : undefined,
        }}
      >
        {/* Let's define some toggles for customizing the code output of snippets */}
        <Toggle
          checked={codegen}
          onClick={() => setCodegen(!codegen)}
          leading={
            <label>
              <Translate>Code generation</Translate>
            </label>
          }
          docsProps={{
            href: "/docs/concepts/about_code_generation",
            title: translate({ message: "About code generation" }),
          }}
        ></Toggle>
        <Toggle
          checked={flutterHooks}
          onClick={() => setFlutterHooks(!flutterHooks)}
          leading={<label>flutter_hooks</label>}
          docsProps={{
            href: "/docs/concepts/about_hooks",
            title: translate({ message: "About hooks" }),
          }}
        ></Toggle>
      </div>

      <hr
        style={{
          backgroundColor: "var(--ifm-toc-border-color)",
          margin: "10px 0",
        }}
      ></hr>
    </>
  );
}

export function Toggle({ checked, onClick, leading, docsProps }) {
  return (
    <div className={clsx("toggle", checked ? "checked" : undefined)}>
      <div style={{ display: "flex", alignItems: "center" }}>
        {leading}
        <button
          type="button"
          onClick={onClick}
          style={{
            marginRight: 5,
            marginLeft: 10,
            transform: "scale(0.8)",
            position: "relative",
            borderRadius: 11,
            display: "block",
            width: 40,
            height: 22,
            flexShrink: 0,
            border: "1px solid rgba(84, 84, 84, .65)",
            transition: "background-color .25s",
          }}
        >
          <span
            style={{
              transform: checked ? "translate(18px)" : undefined,
              position: "absolute",
              top: 1,
              left: 1,
              width: 18,
              height: 18,
              borderRadius: "50%",
              backgroundColor: "#ffffff",
              boxShadow:
                "0 1px 2px rgba(0, 0, 0, .04), 0 1px 2px rgba(0, 0, 0, .06)",
              transition: "background-color .25s,transform .25s",
            }}
          ></span>
        </button>

        <a
          {...docsProps}
          style={{
            borderRadius: "100%",
            border: "green 1px solid",
            width: 20,
            height: 20,
            textAlign: "center",
            color: "green",
            fontSize: 12,
          }}
        >
          ?
        </a>
      </div>
    </div>
  );
}

export default React.memo(DocSidebarDesktop);
