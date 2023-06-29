import raw from "!!raw-loader!./raw.dart";
import codegen from "!!raw-loader!./side_effects.dart";

export default {
  raw,
  hooks: raw,
  codegen,
  hooksCodegen: codegen,
};
