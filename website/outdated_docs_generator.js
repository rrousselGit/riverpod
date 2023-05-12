const fs = require("fs");
const glob = require("glob");
const path = require("path");
const gm = require("gray-matter");

const englishDocFiles = "docs/**/*.mdx";
const translatedDocFiles = "i18n/**/*.mdx";
const outFile = "./src/outdated_translations.js";

async function main() {
  const outdatedTranslations = findOutdatedTranslations().sort((a, b) =>
    a.translation.file.localeCompare(b.translation.file)
  );

  let buffer = "export default [";
  for (const outdatedTranslation of outdatedTranslations) {
    buffer += JSON.stringify(outdatedTranslation.toJson()) + ",";
  }

  buffer += "]";
  fs.writeFileSync(outFile, buffer);
}

function findOutdatedTranslations() {
  const translatedDocs = decodeDocuments(glob.sync(translatedDocFiles));
  const englishDocs = decodeDocuments(glob.sync(englishDocFiles));

  let result = [];
  for (const englishDocList of englishDocs.values()) {
    const englishDoc = englishDocList[0];
    console.log(englishDoc);
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

    const id = parsedDoc.data.id || path.basename(docFile, ".mdx");
    const version = parsedDoc.data.version || 0;

    const list = result.get(id) || [];
    list.push({
      id: id,
      file: docFile,
      document: parsedDoc,
      version: version,
    });
    result.set(id, list);
  }
  return result;
}

class OutdatedTranslation {
  constructor(translation, englishVersion) {
    this.translation = translation;
    this.englishVersion = englishVersion;
  }

  get countryCode() {
    if (!this.translation.file.startsWith("i18n/")) {
      throw new Error(`Unknown path ${this.translation.file}`);
    }

    return this.translation.file.split(path.sep)[1];
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
