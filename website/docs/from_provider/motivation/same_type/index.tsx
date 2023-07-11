import raw from "!!raw-loader!./raw.dart";
import codegen from "!!raw-loader!./same_type.dart";

export default {
  raw,
  hooks: raw,
  codegen,
  hooksCodegen: codegen,
};
