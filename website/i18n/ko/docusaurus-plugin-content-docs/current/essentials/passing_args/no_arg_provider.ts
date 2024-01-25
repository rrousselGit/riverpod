import raw from "!!raw-loader!./raw/provider.dart";
import codegen from "!!raw-loader!./codegen/provider.dart";

export default {
  raw: raw,
  hooks: raw,
  codegen: codegen,
  hooksCodegen: codegen,
};
