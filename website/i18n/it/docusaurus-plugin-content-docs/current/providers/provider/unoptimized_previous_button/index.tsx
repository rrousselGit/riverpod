import raw from "!!raw-loader!./raw.dart";
import codegen from "!!raw-loader!./unoptimized_previous_button.dart";

export default {
  raw,
  hooks: raw,
  codegen,
  hooksCodegen: codegen,
};
