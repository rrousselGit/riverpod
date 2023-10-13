import raw from "!!raw-loader!./raw.dart";
import codegen from "!!raw-loader!./declaration.dart";

export default {
  raw,
  hooks: raw,
  codegen,
  hooksCodegen: codegen,
};
