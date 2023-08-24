import raw from "!!raw-loader!./raw.dart";
import codegen from "!!raw-loader!./from_change_notifier.dart";

export default {
  raw,
  hooks: raw,
  codegen,
  hooksCodegen: codegen,
};
