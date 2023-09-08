import raw from "!!raw-loader!./raw.dart";
import codegen from "!!raw-loader!./family_and_dispose.dart";

export default {
  raw,
  hooks: raw,
  codegen,
  hooksCodegen: codegen,
};
