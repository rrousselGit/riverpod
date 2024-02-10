import raw from "!!raw-loader!./raw.dart";
import codegen from "!!raw-loader!./old_lifecycles_final.dart";

export default {
  raw,
  hooks: raw,
  codegen,
  hooksCodegen: codegen,
};
