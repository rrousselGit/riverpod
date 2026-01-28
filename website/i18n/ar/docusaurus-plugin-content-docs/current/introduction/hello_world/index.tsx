import raw from "!!raw-loader!./raw.dart";
import raw_hooks from "!!raw-loader!./raw_hooks.dart";
import codegen from "!!raw-loader!./main.dart";
import hooksCodegen from "!!raw-loader!./hooks_codegen/main.dart";

export default {
  raw,
  hooks: raw_hooks,
  codegen,
  hooksCodegen: hooksCodegen,
};
