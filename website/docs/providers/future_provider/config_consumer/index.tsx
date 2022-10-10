import raw from "!!raw-loader!./raw.dart";
import codegen from "!!raw-loader!./cgen_config_consumer.dart";
import hooks from "!!raw-loader!./hook_config_consumer.dart";
import hooksCodegen from "!!raw-loader!./hook_cgen_config_consumer.dart"

export default {
  raw,
  hooks,
  codegen,
  hooksCodegen,
};
