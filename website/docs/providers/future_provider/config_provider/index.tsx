import raw from "!!raw-loader!./raw_config_provider.dart";
import codegen from "!!raw-loader!./cgen_provider.dart";

export default {
  raw,
  hooks: raw,
  codegen,
  hooksCodegen: codegen,
};
