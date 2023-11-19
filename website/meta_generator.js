const fs = require("fs");
const glob = require("glob");
const path = require("path");
const gm = require("gray-matter");

const englishDocFiles = "docs/**/*.mdx";
const translatedDocFiles = "i18n/**/*.mdx";
const outFile = "./src/documents_meta.js";

async function main() {
  const translatedDocs = decodeDocuments(glob.sync(translatedDocFiles));
  const englishDocs = decodeDocuments(glob.sync(englishDocFiles));

  let buffer = "";
  buffer += writeDocumentTitles({ englishDocs, translatedDocs });
  buffer += writeOutdatedTranslations({ translatedDocs, englishDocs });

  fs.writeFileSync(outFile, buffer);
}

function writeDocumentTitles({ englishDocs, translatedDocs }) {
  let buffer = "export const documentTitles = {\n";

  buffer += "  'en': {\n";
  for (const englishDocList of englishDocs.values()) {
    if (englishDocList.length > 1) {
      throw new Error(
        `Found multiple English documents with the same id: ${englishDocList[0].id}`
      );
    }

    const englishDoc = englishDocList[0];
    buffer += "    " + JSON.stringify(englishDoc.id) + ": ";
    buffer += JSON.stringify(englishDoc.document.data.title) + ",\n";
  }
  buffer += "  },\n";

  const langs = new Set();
  for (const translatedDocList of translatedDocs.values()) {
    for (const translatedDoc of translatedDocList) {
      langs.add(translatedDoc.countryCode);
    }
  }

  for (const lang of langs) {
    buffer += `  '${lang}': {\n`;
    for (const translatedDocList of translatedDocs.values()) {
      for (const translatedDoc of translatedDocList) {
        if (translatedDoc.countryCode !== lang) continue;

        buffer += "    " + JSON.stringify(translatedDoc.id) + ": ";
        buffer += JSON.stringify(translatedDoc.document.data.title) + ",\n";
      }
    }
    buffer += "  },\n";
  }

  buffer += "};\n";
  return buffer;
}

function writeOutdatedTranslations({ translatedDocs, englishDocs }) {
  const outdatedTranslations = findOutdatedTranslations({
    translatedDocs,
    englishDocs,
  }).sort((a, b) => a.translation.file.localeCompare(b.translation.file));

  let buffer = "export const outdatedTranslations = [\n";
  for (const outdatedTranslation of outdatedTranslations) {
    buffer += JSON.stringify(outdatedTranslation.toJson()) + ",\n";
  }

  buffer += "];\n";
  return buffer;
}

function findOutdatedTranslations({ translatedDocs, englishDocs }) {
  let result = [];
  for (const englishDocList of englishDocs.values()) {
    const englishDoc = englishDocList[0];
    const translatedDocList = translatedDocs.get(englishDoc.id);
    if (translatedDocList) {
      for (const translatedDoc of translatedDocList) {
        if (englishDoc.version > translatedDoc.version) {
          result.push(new OutdatedTranslation(translatedDoc, englishDoc));
        }
      }
    }
  }

  return result;
}

function decodeDocuments(documents) {
  const result = new Map();
  for (const docFile of documents) {
    const parsedDoc = gm.read(docFile);

    let id = parsedDoc.data.id;
    if (!id) {
      let pathSplit;
      if (docFile.startsWith(`docs${path.sep}`)) {
        pathSplit = docFile.split(path.sep).slice(1);
      } else if (docFile.startsWith(`i18n${path.sep}`)) {
        pathSplit = docFile.split(path.sep).slice(4);
      } else {
        throw new Error(`Unknown document type ${docFile}`);
      }

      pathSplit.pop();

      const fileName = path.basename(docFile, ".mdx");

      if (pathSplit.length === 0) id = fileName;
      else id = `${pathSplit.join("/")}/${fileName}`;
    }
    const version = parsedDoc.data.version || 0;

    const list = result.get(id) || [];

    list.push({
      id: id,
      file: docFile,
      document: parsedDoc,
      version: version,
      countryCode: getCountryCodeForPath(docFile),
    });
    result.set(id, list);
  }
  return result;
}

function getCountryCodeForPath(docFile) {
  if (docFile.startsWith(`docs${path.sep}`)) return "en";

  if (!docFile.startsWith(`i18n${path.sep}`)) {
    throw new Error(`Unknown docFile ${docFile}`);
  }

  return docFile.split(path.sep)[1];
}

class OutdatedTranslation {
  constructor(translation, englishVersion) {
    this.translation = translation;
    this.englishVersion = englishVersion;
  }

  get countryCode() {
    return getCountryCodeForPath(this.translation.file);
  }

  toJson() {
    return {
      countryCode: this.countryCode,
      id: this.translation.id,
      englishPath:
        "/" +
        path.dirname(this.englishVersion.file) +
        "/" +
        path.basename(this.englishVersion.file, ".mdx"),
    };
  }
}

main().catch(console.error);
