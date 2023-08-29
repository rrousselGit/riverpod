import React from "react";
import clsx from "clsx";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import Link from "@docusaurus/Link";
import Translate from "@docusaurus/Translate";
import {
  useActivePlugin,
  useDocVersionSuggestions,
} from "@docusaurus/plugin-content-docs/client";
import { ThemeClassNames } from "@docusaurus/theme-common";
import {
  useDocsPreferredVersion,
  useDocsVersion,
} from "@docusaurus/theme-common/internal";
import { useDoc } from "@docusaurus/theme-common/internal";
import { outdatedTranslations } from "../../documents_meta.js";

function UnreleasedVersionLabel({ siteTitle, versionMetadata }) {
  return (
    <Translate
      id="theme.docs.versions.unreleasedVersionLabel"
      description="The label used to tell the user that he's browsing an unreleased doc version"
      values={{
        siteTitle,
        versionLabel: <b>{versionMetadata.label}</b>,
      }}
    >
      {
        "This is unreleased documentation for {siteTitle} {versionLabel} version."
      }
    </Translate>
  );
}
function UnmaintainedVersionLabel({ siteTitle, versionMetadata }) {
  return (
    <Translate
      id="theme.docs.versions.unmaintainedVersionLabel"
      description="The label used to tell the user that he's browsing an unmaintained doc version"
      values={{
        siteTitle,
        versionLabel: <b>{versionMetadata.label}</b>,
      }}
    >
      {
        "This is documentation for {siteTitle} {versionLabel}, which is no longer actively maintained."
      }
    </Translate>
  );
}
const BannerLabelComponents = {
  unreleased: UnreleasedVersionLabel,
  unmaintained: UnmaintainedVersionLabel,
};
function BannerLabel(props) {
  const BannerLabelComponent =
    BannerLabelComponents[props.versionMetadata.banner];
  return <BannerLabelComponent {...props} />;
}
function LatestVersionSuggestionLabel({ versionLabel, to, onClick }) {
  return (
    <Translate
      id="theme.docs.versions.latestVersionSuggestionLabel"
      description="The label used to tell the user to check the latest version"
      values={{
        versionLabel,
        latestVersionLink: (
          <b>
            <Link to={to} onClick={onClick}>
              <Translate
                id="theme.docs.versions.latestVersionLinkLabel"
                description="The label used for the latest version suggestion link label"
              >
                latest version
              </Translate>
            </Link>
          </b>
        ),
      }}
    >
      {
        "For up-to-date documentation, see the {latestVersionLink} ({versionLabel})."
      }
    </Translate>
  );
}
function DocVersionBannerEnabled({ className, versionMetadata }) {
  const {
    siteConfig: { title: siteTitle },
  } = useDocusaurusContext();
  const { pluginId } = useActivePlugin({ failfast: true });
  const getVersionMainDoc = (version) =>
    version.docs.find((doc) => doc.id === version.mainDocId);
  const { savePreferredVersionName } = useDocsPreferredVersion(pluginId);
  const { latestDocSuggestion, latestVersionSuggestion } =
    useDocVersionSuggestions(pluginId);
  // Try to link to same doc in latest version (not always possible), falling
  // back to main doc of latest version
  const latestVersionSuggestedDoc =
    latestDocSuggestion ?? getVersionMainDoc(latestVersionSuggestion);
  return (
    <div
      className={clsx(
        className,
        ThemeClassNames.docs.docVersionBanner,
        "alert alert--warning margin-bottom--md"
      )}
      role="alert"
    >
      <div>
        <BannerLabel siteTitle={siteTitle} versionMetadata={versionMetadata} />
      </div>
      <div className="margin-top--md">
        <LatestVersionSuggestionLabel
          versionLabel={latestVersionSuggestion.label}
          to={latestVersionSuggestedDoc.path}
          onClick={() => savePreferredVersionName(latestVersionSuggestion.name)}
        />
      </div>
    </div>
  );
}

function OutdatedTranslationBanner({ className }) {
  const doc = useDoc();

  for (const outdatedDoc of outdatedTranslations) {
    if (
      outdatedDoc.id === doc.metadata.id &&
      doc.metadata.source.startsWith(`@site/i18n/${outdatedDoc.countryCode}/`)
    ) {
      return (
        <div
          className={clsx(
            className,
            ThemeClassNames.docs.docVersionBanner,
            "alert alert--warning margin-bottom--md"
          )}
          role="alert"
        >
          <div>
            <Translate
              id="custom.outdatedTranslations"
              description="The label used inside the outdated translation banner"
              values={{
                englishLink: (
                  // Not using <Link> but instead raw <a> as <Link to="/docs/foo"> redirects to /fr/docs/foo
                  <a href={outdatedDoc.englishPath}>
                    <Translate
                      id="custom.outdatedTranslationLink"
                      description="The link that redirects to the equivalent English doc"
                    >
                      english version
                    </Translate>
                  </a>
                ),
              }}
            >
              {
                "The content of this page may be outdated. Consider checking out the {englishLink} instead."
              }
            </Translate>
          </div>
        </div>
      );
    }
  }

  return null;
}

export default function DocVersionBanner({ className }) {
  const versionMetadata = useDocsVersion();
  if (versionMetadata.banner) {
    return (
      <DocVersionBannerEnabled
        className={className}
        versionMetadata={versionMetadata}
      />
    );
  }

  return (
    <OutdatedTranslationBanner
      className={className}
    ></OutdatedTranslationBanner>
  );
}
