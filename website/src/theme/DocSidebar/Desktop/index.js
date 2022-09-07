import React, { useContext } from "react";
import clsx from "clsx";
import { useThemeConfig } from "@docusaurus/theme-common";
import Logo from "@theme/Logo";
import CollapseButton from "@theme/DocSidebar/Desktop/CollapseButton";
import Content from "@theme/DocSidebar/Desktop/Content";
import styles from "./styles.module.css";
import { CodegenContext } from "../../DocPage/Layout";

function DocSidebarDesktop({ path, sidebar, onCollapse, isHidden }) {
  const {
    navbar: { hideOnScroll },
    docs: {
      sidebar: { hideable },
    },
  } = useThemeConfig();

  const [codegen, setCodegen] = useContext(CodegenContext);

  return (
    <div
      className={clsx(
        styles.sidebar,
        hideOnScroll && styles.sidebarWithHideableNavbar,
        isHidden && styles.sidebarHidden
      )}
    >
      <Toggle
        checked={codegen}
        onClick={() => setCodegen(!codegen)}
        leading={<label>Code generation</label>}
      ></Toggle>

      {hideOnScroll && <Logo tabIndex={-1} className={styles.sidebarLogo} />}
      <Content path={path} sidebar={sidebar} />
      {hideable && <CollapseButton onClick={onCollapse} />}
    </div>
  );
}

function Toggle({ checked, onClick, leading }) {
  return (
    <div
      style={{
        padding: "12 16px",
        transition: "background-color .5s",
        margin: "6px 0 12px",
        borderRadius: 8,
        fontWeight: 600,
      }}
    >
      <div style={{ display: "flex", alignItems: "center" }}>
        {leading}
        <button
          type="button"
          onClick={onClick}
          style={{
            marginRight: 5,
            transform: "scale(0.8)",
            position: "relative",
            borderRadius: 11,
            display: "block",
            width: 40,
            height: 22,
            flexShrink: 0,
            border: "1px solid rgba(84, 84, 84, .65)",
            transition: "border-color .25s,background-color .25s",
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
      </div>
    </div>
  );
}

export default React.memo(DocSidebarDesktop);
