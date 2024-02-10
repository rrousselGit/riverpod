import raw from "!!raw-loader!./raw.dart";
import codegen from "!!raw-loader!./old_lifecycles.dart";

export default {
  raw,
  hooks: raw,
  codegen,
  hooksCodegen: codegen,
};
