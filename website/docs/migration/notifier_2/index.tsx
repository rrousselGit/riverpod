import raw from "!!raw-loader!./raw.dart";
import codegen from "!!raw-loader!./notifier_2.dart";

export default {
  raw,
  hooks: raw,
  codegen,
  hooksCodegen: codegen,
};
