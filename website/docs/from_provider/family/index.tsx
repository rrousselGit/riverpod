import raw from "!!raw-loader!./raw.dart";
import codegen from "!!raw-loader!./family.dart";

export default {
  raw,
  hooks: raw,
  codegen,
  hooksCodegen: codegen,
};
