import raw from "!!raw-loader!./raw.dart";
import codegen from "!!raw-loader!./from_state_provider.dart";

export default {
  raw,
  hooks: raw,
  codegen,
  hooksCodegen: codegen,
};
