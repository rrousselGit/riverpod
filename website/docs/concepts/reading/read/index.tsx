import raw from "!!raw-loader!./raw.dart";
import raw_hooks from "!!raw-loader!./raw_hooks.dart";
import codegen from "!!raw-loader!./codegen.dart";
import codegen_hooks from "!!raw-loader!./codegen_hooks.dart";

export default {
  raw,
  hooks: raw_hooks,
  codegen,
  hooksCodegen: codegen_hooks,
};
